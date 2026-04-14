module top_module(
    input clk, reset, enable, load,
    input [3:0] in,
    output [3:0] out,
    output overflow
);reg [3:0] counter;
reg [3:0] next_val;

assign overflow = (counter == 4'b1111);

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end else if (load) begin
        next_val <= in;
    end else if (enable) begin
        next_val <= counter + 4'b0001;
    end
end

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end else if (load || enable) begin
        counter <= next_val;
    end
end

assign out = counter;

endmodule