module RLE (
    input clk,
    input rst,
    input data_in,
    output reg [3:0] count,
    output reg data_out,
    output reg valid
);
    reg [3:0] state;
    parameter IDLE = 2'b00, COUNTING = 2'b01, OUTPUT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            data_out <= 0;
            valid <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    count <= 0;
                    if (data_in) begin
                        state <= COUNTING;
                        data_out <= data_in;
                        count <= 1;
                    end
                end
                COUNTING: begin
                    if (data_in == data_out) begin
                        count <= count + 1;
                    end else begin
                        valid <= 1;
                        state <= OUTPUT;
                    end
                end
                OUTPUT: begin
                    // Output the encoded data (count and data_out)
                    valid <= 0;
                    if (data_in) begin
                        state <= COUNTING;
                        data_out <= data_in;
                        count <= 1;
                    end else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule