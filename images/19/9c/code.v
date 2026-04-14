module crc_generator (
    input wire [3:0] data,
    input wire clk,
    input wire rst,
    output reg [3:0] crc
);
    reg [3:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 4'b0;
            crc <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data[3]};
            if (shift_reg[3] ^ data[3]) begin
                shift_reg[3:0] <= shift_reg[3:0] ^ 4'b1011; // polynomial x^4 + x + 1
            end
            crc <= shift_reg;
        end
    end
endmodule