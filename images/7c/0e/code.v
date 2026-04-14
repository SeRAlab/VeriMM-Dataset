module top_module(
    input clk, // clock input
    input rst, // reset input
    input load, // load control input
    input [7:0] in, // parallel input
    output reg [7:0] out // output
);always@(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 8'b0; // reset to all zeros
        end else begin
            if (load) begin
                out <= in; // load the register
            end else begin
                out <= {out[6:0], 1'b0}; // shift left by one bit
            end
        end
    end

endmodule