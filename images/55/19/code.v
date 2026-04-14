module top_module(
    input [3:0] data_in,
    input load,
    input clk,
    output reg [3:0] q
);reg [3:0] q1, q2, q3, q4;

always @(posedge clk) begin
    if(load) begin
        q1 <= data_in;
        q2 <= q1;
        q3 <= q2;
        q4 <= q3;
    end
    else begin
        q1 <= q4;
        q2 <= q1;
        q3 <= q2;
        q4 <= q3;
    end
end

assign q = q4;

endmodule