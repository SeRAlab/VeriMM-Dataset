module turbo_encoder (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [5:0] encoded_out
);
    reg [3:0] shift_reg;
    reg [5:0] temp_encoded;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            encoded_out <= 6'b000000;
        end else begin
            shift_reg <= data_in; // Shift in new data
            temp_encoded[5:4] <= {shift_reg[0] ^ shift_reg[1], shift_reg[2] ^ shift_reg[3]}; // Simple encoding logic
            temp_encoded[3:0] <= shift_reg; // Pass through original data
            encoded_out <= temp_encoded; // Update output
        end
    end
endmodule