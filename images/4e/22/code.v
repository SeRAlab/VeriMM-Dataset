module top_module(
    input data_in,
    input clk,
    input rst,
    input [2:0] delay,
    input [1:0] bypass,
    input [1:0] mode,
    output reg data_out
);reg [2:0] delay_counter;

always @(posedge clk) begin
    if (rst) begin
        data_out <= 1'b0;
        delay_counter <= 3'b0;
    end else begin
        case (mode)
            2'b00: begin // bypass mode
                data_out <= data_in;
            end
            2'b01: begin // delay mode
                if (delay_counter == delay) begin
                    data_out <= data_in;
                    delay_counter <= 3'b0;
                end else begin
                    data_out <= 1'b0;
                    delay_counter <= delay_counter + 1;
                end
            end
            2'b10: begin // mixed mode
                case (bypass)
                    2'b00: begin // bypass input
                        data_out <= data_in;
                    end
                    2'b01, 2'b10: begin // delay input
                        if (delay_counter == delay) begin
                            data_out <= data_in;
                            delay_counter <= 3'b0;
                        end else begin
                            data_out <= 1'b0;
                            delay_counter <= delay_counter + 1;
                        end
                    end
                endcase
            end
        endcase
    end
end

endmodule