module top_module(
    input clk,
    output reg [4:0] johnson_out
);reg [4:0] pipeline1;
reg [4:0] pipeline2;
reg [4:0] pipeline3;
reg [4:0] pipeline4;

always @(posedge clk) begin
    pipeline1 <= johnson_out;
    pipeline2 <= pipeline1;
    pipeline3 <= pipeline2;
    pipeline4 <= pipeline3;
    johnson_out <= {pipeline4[3:0], ~pipeline4[4]};
end

endmodule