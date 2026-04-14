module rle_encoder(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg [7:0] value_out,
    output reg [3:0] count_out,
    output reg valid_out
);
    reg [7:0] current_value;
    reg [3:0] current_count;
    reg encoding_done;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_value <= 0;
            current_count <= 0;
            value_out <= 0;
            count_out <= 0;
            valid_out <= 0;
            encoding_done <= 0;
        end else if (valid_in) begin
            if (encoding_done) begin
                // Reset for new encoding
                current_value <= data_in;
                current_count <= 1;
                encoding_done <= 0;
            end else if (data_in == current_value) begin
                current_count <= current_count + 1;
            end else begin
                // Output the previous run-length encoding
                value_out <= current_value;
                count_out <= current_count;
                valid_out <= 1;
                current_value <= data_in;
                current_count <= 1;
            end
        end else if (valid_out) begin
            valid_out <= 0; // Clear valid signal after output is consumed
        end
    end

    always @(posedge clk) begin
        if (!valid_in && current_count > 0) begin
            // Flush remaining output
            value_out <= current_value;
            count_out <= current_count;
            valid_out <= 1;
            encoding_done <= 1;
        end
    end
endmodule