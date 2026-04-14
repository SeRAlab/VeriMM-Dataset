module shift_register (
    input wire clk,
    input wire rst,
    input wire SI,
    output reg [3:0] PO
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PO <= 4'b0000;
        end else begin
            PO <= {PO[2:0], SI}; // Shift left and insert SI at LSB
        end
    end
endmodule