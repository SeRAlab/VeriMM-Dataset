module top_module(
    input clk,
    input rst,
    output out
    );reg [23:0] counter_d, counter_q;
 
assign out = counter_q[23];
 
always @(counter_q) begin
    counter_d = counter_q + 1'b1;
end
 
always @(posedge clk) begin
    if (rst) begin
        counter_q <= 23'b0;
    end else begin
        counter_q <= counter_d;
    end
end
 
endmodule