module shift_register (
    input wire [7:0] D,
    input wire SH,
    input wire LD,
    input wire CLK,
    output reg [7:0] Q
);
    always @(posedge CLK) begin
        if (LD) begin
            Q <= D; // Load the input data
        end else if (SH) begin
            Q <= {1'b0, Q[7:1]}; // Shift right with 0 fill
        end
    end
endmodule