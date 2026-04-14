module top_module(
    rst, 
    clk, 
    unaligned, 
    ovf, 
    status
);input rst;
input clk;
input unaligned;
input ovf;
output [31:0] status;

reg [31:0] status_reg;

always @(posedge clk) begin
    if (rst) begin
        status_reg <= 32'h0;
    end else begin
        status_reg[1] <= unaligned;
        status_reg[0] <= ovf;
    end
end

assign status = status_reg;

endmodule