module top_module(
    input clk,
    input [7:0] data_in,
    output reg serial_out
);reg [7:0] shift_reg;
reg [2:0] counter;

always @(posedge clk) begin
    if (counter == 0) begin
        shift_reg <= data_in;
        counter <= 1;
    end else begin
        shift_reg <= {shift_reg[6:0], 1'b0};
        counter <= counter + 1;
    end
end

always @(posedge clk) begin
    if (counter == 0) begin
        serial_out <= shift_reg[7];
    end else if (counter == 1) begin
        serial_out <= shift_reg[6];
    end else if (counter == 2) begin
        serial_out <= shift_reg[5];
    end else if (counter == 3) begin
        serial_out <= shift_reg[4];
    end else if (counter == 4) begin
        serial_out <= shift_reg[3];
    end else if (counter == 5) begin
        serial_out <= shift_reg[2];
    end else if (counter == 6) begin
        serial_out <= shift_reg[1];
    end else if (counter == 7) begin
        serial_out <= shift_reg[0];
        counter <= 0;
    end
end

endmodule