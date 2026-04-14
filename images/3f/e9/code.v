module LZW_Compressor(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg [11:0] code_out,
    output reg valid,
    output reg done
);
    parameter IDLE = 2'b00, READ = 2'b01, OUTPUT = 2'b10;
    reg [1:0] state, next_state;

    reg [7:0] dictionary [0:255]; // Simple dictionary for LZW
    reg [7:0] current_string [0:255];
    reg [7:0] next_char;
    reg [8:0] dict_size;
    
    initial begin
        dict_size = 0;
        valid = 0;
        done = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            valid <= 0;
            done <= 0;
            dict_size <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = READ;
                end else begin
                    next_state = IDLE;
                end
            end
            READ: begin
                // Read input and handle dictionary
                if (dict_size < 256) begin
                    current_string[dict_size] = data_in;
                    code_out = dict_size; // Output the code for the current string
                    valid = 1;
                    dict_size = dict_size + 1;
                    next_state = OUTPUT;
                end else begin
                    next_state = OUTPUT; // Move to output state after filling the dictionary
                end
            end
            OUTPUT: begin
                // Output code logic
                valid = 0;
                if (dict_size >= 256) begin
                    done = 1; // Indicate done processing
                    next_state = IDLE; // Reset to idle state
                end else begin
                    next_state = READ; // Continue reading
                end
            end
        endcase
    end
endmodule