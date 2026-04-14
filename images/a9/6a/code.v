module top_module(
    DataIn,
    DataOut1,
    DataOut2,
    clk,
    rst
);input [3:0] DataIn;
output [3:0] DataOut1;
wire [3:0] DataOut1;
output [3:0] DataOut2;
wire [3:0] DataOut2;
input clk;
input rst;

reg [3:0] Buffer;



always @(posedge clk, negedge rst) begin: PIPO_S2_LOGIC
    if (rst) begin
        Buffer <= 0;
    end
    else begin
        Buffer <= DataIn;
    end
end



assign DataOut1 = Buffer;
assign DataOut2 = Buffer;

endmodule