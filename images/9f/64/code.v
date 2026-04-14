module dual_port_ram(
   input                clk,
   input                wr_en,
   input [5:0]          wr_addr,
   input [15:0]         wr_data,
   input [5:0]          rd_addr,
 
   output reg [15:0]    rd_data
);
    reg [15:0] memory [63:0];

    always@(posedge clk) begin
        if (wr_en) begin
            memory[wr_addr] <= wr_data;
        end
        rd_data <= memory[rd_addr];
    end
endmodule