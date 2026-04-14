module lzw_compressor(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg [11:0] code_out,
    output reg valid
);
    reg [7:0] dictionary[0:255];
    reg [7:0] current_string;
    reg [7:0] next_char;
    reg [7:0] code_index;
    
    initial begin
        code_index = 0;
        valid = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            code_index <= 0;
            valid <= 0;
            current_string <= 0;
        end else if (start) begin
            next_char <= data_in;
            if (dictionary[current_string] == next_char) begin
                current_string <= current_string; // Continue building string
            end else begin
                code_out <= dictionary[current_string]; // Output code
                valid <= 1; // Signal that output is valid
                current_string <= next_char; // Update current string
                code_index <= code_index + 1; // Move to next code in dictionary
            end
        end
    end
endmodule