module rle_encoder(
    input wire clk,
    input wire valid,
    input wire [7:0] data_in,
    output reg [7:0] out_value,
    output reg [7:0] out_count,
    output reg out_valid
);
    reg [7:0] current_value;
    reg [7:0] count;
    reg [3:0] state; // 0: idle, 1: counting, 2: output

    always @(posedge clk) begin
        if (valid) begin
            if (state == 0) begin
                current_value <= data_in;
                count <= 1;
                state <= 1;
                out_valid <= 0;
            end else if (state == 1) begin
                if (data_in == current_value) begin
                    count <= count + 1;
                end else begin
                    out_value <= current_value;
                    out_count <= count;
                    out_valid <= 1;
                    current_value <= data_in;
                    count <= 1;
                end
            end else if (state == 2) begin
                out_valid <= 0;
                if (data_in != current_value) begin
                    state <= 1; // continue counting
                end
            end
        end else begin
            state <= 0; // reset state when valid is low
        end
    end
endmodule