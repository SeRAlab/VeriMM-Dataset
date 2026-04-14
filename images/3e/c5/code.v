module adc_simulator (
    input wire clk,
    input wire reset,
    input wire [7:0] binary_input,
    output reg [7:0] decimal_output
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        decimal_output <= 8'b00000000; // Initialize output to 0 on reset
    end else begin
        decimal_output <= binary_input; // Output the binary input directly
    end
end

endmodule