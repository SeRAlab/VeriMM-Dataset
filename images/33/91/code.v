module shift_register (
    input wire clk,
    input wire rst,
    input wire D,
    output reg [1:0] Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 2'b00;
        end else begin
            Q <= {D, Q[1]};
        end
    end
endmodule