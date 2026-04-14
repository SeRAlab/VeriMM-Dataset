module rle_encoder(
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] count,
    output reg value,
    output reg valid_out
);
    reg [7:0] current_value;
    reg [7:0] run_length;
    reg [3:0] state; // 0: IDLE, 1: COUNT, 2: OUTPUT, 3: DONE

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            count <= 8'b0;
            value <= 1'b0;
            valid_out <= 1'b0;
            run_length <= 8'b0;
            current_value <= 8'b0;
        end else begin
            case (state)
                0: begin // IDLE
                    if (data_valid) begin
                        current_value <= data_in;
                        run_length <= 1;
                        state <= 1;
                    end
                end
                1: begin // COUNT
                    if (data_valid && data_in == current_value) begin
                        run_length <= run_length + 1;
                    end else begin
                        count <= run_length;
                        value <= current_value[0]; // Assuming 8-bit, only using LSB for encoding
                        state <= 2;
                    end
                end
                2: begin // OUTPUT
                    valid_out <= 1'b1;
                    state <= 3;
                end
                3: begin // DONE
                    valid_out <= 0;
                    if (data_valid) begin
                        current_value <= data_in;
                        run_length <= 1;
                        state <= 1;
                    end else begin
                        state <= 0;
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule