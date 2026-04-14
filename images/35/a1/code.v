module sd_card_controller (
    input clk,
    input rst,
    input [1:0] cmd, // 00: IDLE, 01: WRITE, 10: READ
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [1:0] status // 00: IDLE, 01: WRITE, 10: READ
);
    reg [7:0] data_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg <= 8'b0;
            data_out <= 8'b0;
            status <= 2'b00;
        end else begin
            case (cmd)
                2'b01: begin // WRITE
                    data_reg <= data_in;
                    status <= 2'b01;
                end
                2'b10: begin // READ
                    data_out <= data_reg;
                    status <= 2'b10;
                end
                default: begin
                    status <= 2'b00; // IDLE
                end
            endcase
        end
    end
endmodule