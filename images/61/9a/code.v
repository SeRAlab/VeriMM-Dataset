module shift_load_register (
    input clk,
    input load,
    input shift,
    input reset,
    input [3:0] D,
    input serial_in,
    output reg [3:0] Q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 4'b0000;
        else if (load)
            Q <= D;
        else if (shift)
            Q <= {Q[2:0], serial_in};
    end

endmodule