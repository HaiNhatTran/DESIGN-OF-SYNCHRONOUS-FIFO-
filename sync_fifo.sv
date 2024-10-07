`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2024 01:48:42 PM
// Design Name: 
// Module Name: sync_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sync_fifo (
    input logic        clk,
    input logic        rst_n,
    
    input logic        wr_en_i,
    input logic  [7:0] data_i,
    output logic       full_o,
    
    input logic        rd_en_i,
    output logic [7:0] data_o,
    output logic       empty_o
);
    
parameter int DEPTH = 8;

logic [7:0] mem [0 : DEPTH - 1];
logic [2:0] wr_ptr;
logic [2:0] rd_ptr; 
logic [3:0] count;

// Full and Empty logic
assign full_o  = (count == DEPTH);
assign empty_o = (count == 0);

// Write Process
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr <= 3'd0;
    end else if (wr_en_i && !full_o) begin
        mem[wr_ptr] <= data_i;
        wr_ptr <= wr_ptr + 1;
    end
end

// Read Process
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_ptr <= 3'd0;
    end else if (rd_en_i && !empty_o) begin
        data_o <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
    end
end

// Counter Process
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'd0;
    end else begin
        case ({wr_en_i && !full_o, rd_en_i && !empty_o})
            2'b10: count <= count + 1; // Write without read
            2'b01: count <= count - 1; // Read without write
            2'b11: count <= count;     // Simultaneous read/write, no change
            2'b00: count <= count;     // No action
        endcase
    end
end
endmodule

