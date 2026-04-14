module LZW_Encoder (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] symbol_in,
    output reg [3:0] code_out,
    output reg valid
);
    reg [7:0] dictionary [0:3]; // Simple dictionary with 4 entries
    reg [1:0] current_state;
    
    initial begin
        // Initialize the dictionary
        dictionary[0] = 8'h41; // 'A'
        dictionary[1] = 8'h42; // 'B'
        dictionary[2] = 8'h43; // 'C'
        dictionary[3] = 8'h44; // 'D'
        current_state = 2'b00;
        code_out = 4'b0000;
        valid = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 2'b00;
            code_out <= 4'b0000;
            valid <= 0;
        end else if (enable) begin
            case (current_state)
                2'b00: begin
                    // Check input symbol
                    if (symbol_in == dictionary[0]) begin
                        code_out <= 4'b0000; // Code for 'A'
                        valid <= 1;
                    end else if (symbol_in == dictionary[1]) begin
                        code_out <= 4'b0001; // Code for 'B'
                        valid <= 1;
                    end else if (symbol_in == dictionary[2]) begin
                        code_out <= 4'b0010; // Code for 'C'
                        valid <= 1;
                    end else if (symbol_in == dictionary[3]) begin
                        code_out <= 4'b0011; // Code for 'D'
                        valid <= 1;
                    end else begin
                        code_out <= 4'b0000; // Default code
                        valid <= 0;
                    end
                    current_state <= 2'b01; // Move to next state
                end
                2'b01: begin
                    // Waiting for next input
                    current_state <= 2'b00; // Go back to initial state
                end
            endcase
        end
    end
endmodule