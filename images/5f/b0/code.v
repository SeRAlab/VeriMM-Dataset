module top_module(
    input clk,
    input up_down,
    input reset,
    input [3:0] data_in,
    output reg [3:0] q,  // Change to reg type
    output reg out
);reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0;
    end else begin
        q <= count;
    end
end

always @(posedge clk) begin
    if (reset) begin
        out <= 1'b0;
    end else if (count > data_in) begin
        out <= 1'b1;
    end else begin
        out <= 1'b0;
    end
end

endmodule