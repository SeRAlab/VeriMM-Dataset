module top_module(
    input clk,
    input rst,
    input load,
    input up_down,
    input [3:0] load_val,
    output reg [3:0] out
);always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000;
    end else if (load) begin
        out <= load_val;
    end else if (up_down) begin
        out <= out + 1;
    end else begin
        out <= out - 1;
    end
end

endmodule