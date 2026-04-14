module rle_encoder(
    input clk,
    input reset,
    input [7:0] data_in,
    input valid_in,
    output reg [7:0] encoded_value,
    output reg [3:0] run_length,
    output reg valid_out
);
    reg [7:0] current_value;
    reg [3:0] current_length;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_value <= 0;
            current_length <= 0;
            encoded_value <= 0;
            run_length <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            if (data_in == current_value) begin
                if (current_length < 15) begin
                    current_length <= current_length + 1;
                end
            end else begin
                if (current_length > 0) begin
                    encoded_value <= current_value;
                    run_length <= current_length;
                    valid_out <= 1;
                end
                current_value <= data_in;
                current_length <= 1;
            end
        end
    end

    always @(posedge clk) begin
        if (valid_out) begin
            valid_out <= 0; // Clear valid output after reading
        end
    end

endmodule