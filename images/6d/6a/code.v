module top_module(
    input  D,
    output reg Q,  // Changed here to reg
    input  CLK
);reg reg1 = 0;
    reg reg2 = 1;

    always @(posedge CLK) begin
        reg1 <= D;
    end

    always @(posedge CLK) begin
        reg2 <= reg1;
    end

    always @(posedge CLK) begin
        Q <= reg1;   // Q needs to be of type reg to be assigned
        reg2 <= ~reg2;
    end

endmodule