module shift_register_8bit (
    input clk,
    input reset,
    input serial_in,
    output reg [7:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 8'b00000000;
    else
        q <= {q[6:0], serial_in};
    end
    
endmodule