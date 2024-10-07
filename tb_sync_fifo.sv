`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2024 01:49:15 PM
// Design Name: 
// Module Name: tb_sync_fifo
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

`define clk_period 10

module tb_sync_fifo();

logic clk, rst_n;
logic wr_en_i, rd_en_i;
logic [7:0] data_i;

logic [7:0] data_o;
logic full_o, empty_o;

// Instantiate the FIFO
sync_fifo SYNC_FIFO(
    .clk(clk),
    .rst_n(rst_n),
    
    .wr_en_i(wr_en_i),
    .data_i(data_i),
    
    .rd_en_i(rd_en_i),
    .data_o(data_o),
    
    .full_o(full_o),
    .empty_o(empty_o)
);

// Clock generation
always #(`clk_period/2) clk = ~clk;

initial begin
    clk = 1'b1;  // Initialize clock to 1
end

integer i;
initial begin
    // Apply reset
    rst_n = 1'b1;
    wr_en_i = 1'b0;
    rd_en_i = 1'b0;
    data_i = 8'b0;

    // Hold reset for a clock cycle
    #(`clk_period);
    rst_n = 1'b0;  // Deassert reset after 1 clock cycle
    
    #(`clk_period);
    rst_n = 1'b1; // Finish reset
    
    // Write data to FIFO (8 entries)
    wr_en_i = 1'b1;
    rd_en_i = 1'b0;
    
    for (i = 0; i < 8; i = i + 1) begin
        data_i = i;    // Write incremental data
        #(`clk_period);
    end
    wr_en_i = 1'b0;  // Stop writing

    // Read data from FIFO (8 data)
    wr_en_i = 1'b0;
    rd_en_i = 1'b1;
    
    for (i = 0; i < 8; i = i + 1) begin
        #(`clk_period);
    end
    rd_en_i = 1'b0;  // Stop reading

    // Write data again to FIFO (8 data)
    wr_en_i = 1'b1;
    rd_en_i = 1'b0;
    
    for (i = 0; i < 8; i = i + 1) begin
        data_i = i;    // Write incremental data with different values
        #(`clk_period);
    end
    wr_en_i = 1'b0;  // Stop writing
    
 // Read data from FIFO (8 data)
    wr_en_i = 1'b0;
    rd_en_i = 1'b1;
    
    for (i = 0; i < 8; i = i + 1) begin
        #(`clk_period);
    end
    rd_en_i = 1'b0;  // Stop reading
    // Wait to observe behavior
    #(`clk_period);
    #(`clk_period);
    #(`clk_period);
    $stop; // Stop the simulation
end

endmodule

