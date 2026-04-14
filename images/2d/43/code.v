module siso_shift_register (
    input wire clk,
    input wire rst,
    input wire s_in,
    output reg [4:0] s_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s_out <= 5'b00000; // Reset the output
        end else begin
            s_out <= {s_out[3:0], s_in}; // Shift left and insert s_in
        end
    end
endmodule