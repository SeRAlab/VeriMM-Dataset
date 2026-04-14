module shift_register (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [1:0] q
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 2'b00; // Asynchronous reset
        end else begin
            q <= {q[0], serial_in}; // Shift left
        end
    end

endmodule