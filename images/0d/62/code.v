module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] addr1,
    input wire [7:0] addr2,
    output reg [7:0] data_out1,
    output reg [7:0] data_out2
);
    reg [7:0] memory [255:0]; // Example memory space

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out1 <= 8'b0;
            data_out2 <= 8'b0;
        end else if (start) begin
            data_out1 <= memory[addr1];
            data_out2 <= memory[addr2];
        end
    end
endmodule