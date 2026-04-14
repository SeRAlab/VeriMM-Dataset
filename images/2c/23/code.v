module rle_encoder (
    input clk,
    input reset,
    input bit_in,
    output reg [3:0] count,
    output reg bit_out,
    output reg valid
);
    reg [3:0] current_count;
    reg current_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_count <= 0;
            valid <= 0;
        end else begin
            if (current_count == 0) begin
                current_bit <= bit_in;
                current_count <= 1;
                valid <= 0;
            end else if (bit_in == current_bit) begin
                current_count <= current_count + 1;
                valid <= 0;
            end else begin
                count <= current_count;
                bit_out <= current_bit;
                valid <= 1;
                current_bit <= bit_in;
                current_count <= 1;
            end
        end
    end
endmodule