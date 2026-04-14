module chacha20_core(
    input clk,
    input reset,
    input [31:0] key,
    input [31:0] nonce,
    output reg [31:0] output_data
);
    
    reg [31:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 32'b0;
            output_data <= 32'b0;
        end else begin
            state <= key ^ nonce; // Simple combination of key and nonce
            output_data <= state; // Output the current state
        end
    end
endmodule