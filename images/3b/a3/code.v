module rle_encoder (
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] out_value,
    output reg [3:0] out_count,
    output reg out_valid
);
    reg [7:0] current_value;
    reg [3:0] current_count;
    reg [2:0] state;
    reg [2:0] run_length;

    localparam IDLE = 3'b000;
    localparam COUNT = 3'b001;
    localparam OUTPUT = 3'b010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            out_valid <= 0;
            current_count <= 0;
            run_length <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_valid) begin
                        current_value <= data_in;
                        current_count <= 1;
                        state <= COUNT;
                    end
                end
                COUNT: begin
                    if (data_valid) begin
                        if (data_in == current_value) begin
                            current_count <= current_count + 1;
                        end else begin
                            out_value <= current_value;
                            out_count <= current_count;
                            out_valid <= 1;
                            current_value <= data_in;
                            current_count <= 1;
                            state <= OUTPUT;
                        end
                    end
                end
                OUTPUT: begin
                    out_valid <= 0;
                    if (data_valid) begin
                        if (run_length < 7) begin
                            run_length <= run_length + 1;
                            state <= COUNT;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end
endmodule