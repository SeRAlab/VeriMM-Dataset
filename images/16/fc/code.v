module mux32to1 (
    input [31:0] data,        // 32 data inputs
    input [4:0] select,       // 5-bit select input
    input reset,              // Reset signal
    output reg out            // Output
);
    always @(*) begin
        if (reset) begin
            out = 1'b0;        // Initialize output to 0 on reset
        end else begin
            out = data[select]; // Select the appropriate data input
        end
    end
endmodule