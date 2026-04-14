module rle_encoder (
    input clk,
    input rst,
    input bit_in,
    output reg [7:0] run_value,
    output reg [7:0] run_length,
    output reg valid
);
    reg [7:0] count;
    reg [7:0] current_bit;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b0;
            current_bit <= 8'b0;
            run_value <= 8'b0;
            run_length <= 8'b0;
            valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (bit_in) begin
                        current_bit <= 1;
                        count <= 1;
                        state <= 1;
                    end else begin
                        current_bit <= 0;
                        count <= 1;
                        state <= 1;
                    end
                end
                1: begin
                    if (bit_in == current_bit) begin
                        count <= count + 1;
                    end else begin
                        run_value <= current_bit;
                        run_length <= count;
                        valid <= 1;
                        current_bit <= bit_in;
                        count <= 1;
                        state <= 2;
                    end
                end
                2: begin
                    if (bit_in == current_bit) begin
                        count <= count + 1;
                    end else begin
                        run_value <= current_bit;
                        run_length <= count;
                        valid <= 1;
                        current_bit <= bit_in;
                        count <= 1;
                        state <= 1;
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule