module my_flip_flop (
    output Q   ,
    input  CLK ,
    input  D   ,
    input  DE  ,
    input  VPWR,
    input  VGND
);

    reg Q;

    always @(posedge CLK) begin
        if (DE) begin
            Q <= D;
        end
    end

endmodule