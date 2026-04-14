module lzw_encoder (
    input clk,
    input reset,
    input [7:0] char_in,
    input valid_in,
    output reg [15:0] code_out,
    output reg valid_out
);
    reg [15:0] dictionary [0:255];
    reg [7:0] current_string;
    reg [7:0] next_char;
    integer next_index;

    initial begin
        // Initialize the dictionary with single character codes
        for (next_index = 0; next_index < 256; next_index = next_index + 1) begin
            dictionary[next_index] = next_index;
        end
        next_index = 256; // Start adding new entries after the initial 256
        current_string = 8'b0;
        code_out = 16'b0;
        valid_out = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_string <= 8'b0;
            code_out <= 16'b0;
            valid_out <= 0;
        end else if (valid_in) begin
            next_char = char_in;
            if (dictionary[current_string] != 16'b0) begin
                // If current_string + next_char is in the dictionary
                // Output the code for current_string
                code_out <= dictionary[current_string];
                valid_out <= 1;
                // Update current_string
                current_string <= {current_string, next_char}; // Concatenate
                if (next_index < 1024) begin
                    // Add new entry into the dictionary
                    dictionary[next_index] = current_string;
                    next_index = next_index + 1;
                end
            end else begin
                // Output the code for current_string
                code_out <= dictionary[current_string];
                valid_out <= 1;
                // Reset current_string to next_char
                current_string <= next_char;
            end
        end else begin
            valid_out <= 0;
        end
    end
endmodule