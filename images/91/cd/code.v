module top_module(
    input clk,
    input reset,
    input load,
    input up_down,
    input [3:0] in_value,
    output reg [3:0] count
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (load) begin
        count <= in_value;
    end else if (up_down) begin
        count <= count + 4'b0001;
    end else begin
        count <= count - 4'b0001;
    end
end

endmodule