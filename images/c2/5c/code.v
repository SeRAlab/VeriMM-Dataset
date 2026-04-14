module shift_register(clk, rst, shift_in, shift, shift_out);
    input clk, rst, shift;
    input [7:0] shift_in;
    output reg [7:0] shift_out;

    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            shift_out <= 8'b0;
        end else if (shift) begin
            shift_out <= {shift_out[6:0], shift_in};
        end
    end
endmodule