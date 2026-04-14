module top_module(
    input clk,
    input rst,
    input load,
    input up_down,
    input [3:0] in, // Added input for loading value
    output reg [3:0] out
);reg [3:0] count;

always @(posedge clk) begin
    if (rst) begin
        count <= 4'b0;
    end else if (load) begin
        count <= in; // Correctly load the input value
    end else if (up_down) begin
        count <= (count == 4'b1111) ? 4'b0 : count + 1;
    end else begin
        count <= (count == 4'b0000) ? 4'b1111 : count - 1;
    end
end

always @* begin
    out = count; // Changed to assign 'count' to 'out' in an always block
end

endmodule