module top_module(
    input clk,
    input [63:0] probe0,
    input [63:0] probe1,
    input [0:0] probe2,
    input [0:0] probe3,
    input [0:0] probe4,
    input [0:0] probe5,
    input [0:0] probe6,
    input [63:0] probe7,
    input [0:0] probe8,
    input [0:0] probe9,
    input [0:0] probe10,
    input [0:0] probe11,
    input [63:0] probe12,
    input [0:0] probe13,
    input [0:0] probe14,
    input [0:0] probe15,
    input [0:0] probe16,
    input [0:0] probe17,
    input [7:0] probe18,
    input [8:0] probe19,
    input [0:0] probe20,
    input [2:0] probe21,
    input [2:0] probe22,
    input [0:0] probe23,
    input [7:0] probe24,
    output reg [63:0] output0,
    output reg output1,
    output reg [63:0] output2,
    output reg [7:0] output3,
    output reg [8:0] output4
);always @(posedge clk) begin
    output0 <= {probe0, probe1};
    output1 <= &{probe2, probe3, probe4, probe5, probe6};
    output2 <= {probe7, probe12};
    output3 <= {probe18, probe24};
    output4 <= {probe19, probe21, probe22};
end

endmodule