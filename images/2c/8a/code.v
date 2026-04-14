module rle_encoder (
    input wire clk,
    input wire reset,
    input wire bit_in,
    input wire done,
    output reg [7:0] encoded_bit,
    output reg [7:0] run_length,
    output reg valid
);
    reg [7:0] count;
    reg current_bit;
    reg encoding_done;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            current_bit <= 0;
            valid <= 0;
            encoding_done <= 0;
        end else if (done) begin
            encoding_done <= 1;
        end else begin
            if (count == 0) begin
                current_bit <= bit_in;
                count <= 1;
            end else if (bit_in == current_bit) begin
                count <= count + 1;
            end else begin
                encoded_bit <= current_bit;
                run_length <= count;
                valid <= 1;
                current_bit <= bit_in;
                count <= 1;
            end
        end
    end

    always @(posedge clk) begin
        if (encoding_done) begin
            encoded_bit <= current_bit;
            run_length <= count;
            valid <= 1;
        end
    end
endmodule