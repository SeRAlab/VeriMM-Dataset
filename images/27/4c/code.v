module rle_encoder (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [15:0] data_out,
    output reg valid
);
    reg [7:0] last_bit;
    reg [7:0] count;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            last_bit <= 8'b0;
            count <= 0;
            data_out <= 16'b0;
            valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    last_bit <= data_in;
                    count <= 1;
                    state <= 1;
                    valid <= 0;
                end
                1: begin
                    if (data_in == last_bit) begin
                        count <= count + 1;
                    end else begin
                        data_out <= {last_bit, count};
                        valid <= 1;
                        last_bit <= data_in;
                        count <= 1;
                        state <= 1;
                    end
                end
            endcase
        end
    end
endmodule