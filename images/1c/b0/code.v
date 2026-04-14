module LZW_Compression(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [11:0] code_out,
    output reg valid
);
    reg [7:0] dictionary [0:255]; // Simple fixed-size dictionary
    reg [7:0] current_seq;
    reg [7:0] next_char;
    integer dict_index;
    integer seq_length;

    initial begin
        dict_index = 0;
        seq_length = 1;
        valid = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dict_index <= 0;
            current_seq <= 0;
            code_out <= 0;
            valid <= 0;
        end else begin
            if (seq_length < 256) begin
                next_char = data_in;
                if (current_seq == 0 || dictionary[current_seq] == next_char) begin
                    current_seq <= current_seq + 1;
                end else begin
                    code_out <= current_seq;
                    valid <= 1;
                    dictionary[dict_index] <= next_char;
                    dict_index <= dict_index + 1;
                    current_seq <= 1; // Reset to the first sequence
                end
            end else begin
                code_out <= 12'hFFF; // Indicating full dictionary
                valid <= 0;
            end
        end
    end
endmodule