module rle_encoder (
    input clk,
    input reset,
    input bit_in,
    output reg [1:0] value_out,
    output reg [3:0] count_out,
    output reg valid
);
    reg [1:0] current_value;
    reg [3:0] current_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_value <= 0;
            current_count <= 0;
            value_out <= 0;
            count_out <= 0;
            valid <= 0;
        end else if (bit_in == current_value) begin
            current_count <= current_count + 1;
        end else begin
            if (current_count > 0) begin
                value_out <= current_value;
                count_out <= current_count;
                valid <= 1;
            end
            current_value <= bit_in;
            current_count <= 1;
        end
    end

    always @(posedge clk) begin
        if (valid) begin
            valid <= 0;
        end
    end
endmodule