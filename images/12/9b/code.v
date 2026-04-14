module rle_encoder (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire data_valid,
    output reg [7:0] rle_value,
    output reg [7:0] rle_count,
    output reg rle_ready
);
    reg [7:0] current_value;
    reg [7:0] count;
    reg encoding;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rle_value <= 0;
            rle_count <= 0;
            rle_ready <= 0;
            current_value <= 0;
            count <= 0;
            encoding <= 0;
        end else if (data_valid) begin
            if (!encoding) begin
                current_value <= data_in;
                count <= 1;
                encoding <= 1;
            end else if (data_in == current_value) begin
                count <= count + 1;
            end else begin
                rle_value <= current_value;
                rle_count <= count;
                rle_ready <= 1;
                current_value <= data_in;
                count <= 1;
            end
        end else if (encoding) begin
            rle_value <= current_value;
            rle_count <= count;
            rle_ready <= 1;
            encoding <= 0;
        end
    end
endmodule