module top_module(
    DataIn,
    DataOut1,
    DataOut2,
    clk,
    rst
);input [3:0] DataIn;
output [3:0] DataOut1;
reg [3:0] DataOut1;
output [3:0] DataOut2;
reg [3:0] DataOut2;
input clk;
input rst;




always @(posedge clk, negedge rst) begin: PIPO_S1_LOGIC
    if (rst) begin
        DataOut1 <= 0;
        DataOut2 <= 0;
    end
    else begin
        DataOut1 <= DataIn;
        DataOut2 <= DataIn;
    end
end

endmodule