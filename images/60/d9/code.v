module top_module(
    input reset,
    input clk,
    input ld,
    input [7:0] acc_in,
    output reg [7:0] acc_out
    );always@(posedge clk or posedge reset)begin
    if(reset)
        acc_out <= 8'b0000_0000;
    else
        if(ld)
            acc_out <= acc_in;
end
endmodule