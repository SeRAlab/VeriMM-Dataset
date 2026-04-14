module chacha20_simple (
    input wire clk,
    input wire reset,
    input wire [31:0] input_data,
    output reg [31:0] output_data
);
    reg [31:0] constant = 32'h1B2D3F4A; // Example constant

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_data <= 32'b0;
        end else begin
            output_data <= input_data ^ constant; // Simple XOR operation
        end
    end
endmodule