module top_module(
    input clk,
    input load,
    input clear,
    input [31:0] d,
    output reg [31:0] q
);

    // Always block triggered on the rising edge of the clock or on clear
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            q <= 32'b0;  // Asynchronous clear to zero
        end else if (load) begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule