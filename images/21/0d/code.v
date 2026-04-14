module shift_register (
    input clk,
    input rst,
    input load,
    input shift,
    input [15:0] din,
    output reg [15:0] dout
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dout <= 16'b0;
    end else if (load) begin
        dout <= din;
    end else begin
        if (shift) begin
            dout <= {dout[14:0], 1'b0}; // Left shift
        end else begin
            dout <= {1'b0, dout[15:1]}; // Right shift
        end
    end
end

endmodule