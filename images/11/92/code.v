module sd_card_controller(
    input wire clk,
    input wire rst,
    input wire [1:0] cmd,   // 00: idle, 01: write, 10: read
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg ready
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
            ready <= 1'b1;
        end else begin
            case (cmd)
                2'b01: begin // write command
                    data_out <= data_in;
                    ready <= 1'b0; // not ready until the operation is complete
                end
                2'b10: begin // read command
                    data_out <= data_out; // simulate reading the data that was written
                    ready <= 1'b0; // not ready until the operation is complete
                end
                default: begin
                    ready <= 1'b1; // ready for a new command
                end
            endcase
        end
    end
endmodule