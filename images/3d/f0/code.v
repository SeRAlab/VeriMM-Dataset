module LZW_Compressor (
    input clk,
    input reset,
    input [7:0] data_in,
    input valid,
    output reg [11:0] compressed_out,
    output reg valid_out
);
    parameter MAX_SIZE = 4096; // Dictionary size
    reg [7:0] dictionary[MAX_SIZE-1:0]; // Simple dictionary
    reg [11:0] next_code;
    reg [7:0] current_seq;
    reg [11:0] code_out;

    initial begin
        next_code = 0;
        valid_out = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_code <= 0;
            valid_out <= 0;
        end else if (valid) begin
            if (next_code < MAX_SIZE) begin
                // Simplified LZW logic
                current_seq = data_in;
                code_out = next_code;
                compressed_out <= code_out;
                valid_out <= 1;
                next_code <= next_code + 1;
            end else begin
                // Dictionary full
                valid_out <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
endmodule