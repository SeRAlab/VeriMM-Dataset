module chacha20_simple (
    input wire clk,
    input wire reset,
    input wire [31:0] key,
    output reg [31:0] stream
);
    reg [31:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stream <= 32'b0;
            counter <= 32'b0;
        end else begin
            counter <= counter + 1;
            stream <= key ^ counter;  // Simple XOR combination for demonstration
        end
    end
endmodule