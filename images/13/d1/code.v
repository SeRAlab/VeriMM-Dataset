module rle_encoder(
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] run_length,
    output reg [7:0] run_value,
    output reg output_valid
);
    reg [7:0] count;
    reg [7:0] current_value;
    reg [3:0] state;

    parameter IDLE = 4'b0000, COUNT = 4'b0001, OUTPUT = 4'b0010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            run_length <= 0;
            run_value <= 0;
            output_valid <= 0;
            count <= 0;
            current_value <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (data_valid) begin
                        current_value <= data_in;
                        count <= 1;
                        state <= COUNT;
                    end
                end
                COUNT: begin
                    if (data_valid && data_in == current_value) begin
                        count <= count + 1;
                    end else begin
                        run_length <= count;
                        run_value <= current_value;
                        output_valid <= 1;
                        state <= OUTPUT;
                    end
                end
                OUTPUT: begin
                    output_valid <= 0;
                    if (!data_valid) begin
                        state <= IDLE;
                    end else begin
                        current_value <= data_in;
                        count <= 1;
                        state <= COUNT;
                    end
                end
            endcase
        end
    end
endmodule