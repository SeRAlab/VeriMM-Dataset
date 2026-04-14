module shiftreg8bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift,
    input wire shift_dir,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 8'b00000000;
        else if (load)
            data_out <= data_in;
        else if (shift) begin
            if (shift_dir)
                data_out <= data_out << 1;
            else
                data_out <= data_out >> 1;
        end
    end

endmodule