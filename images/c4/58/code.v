module cantidadecho (
    input [7:0] cantidad,
    input entrada,
    input CLKOUT,
    input reset,
    output reg ECHO
);

reg [3:0] count;
reg [3:0] delay;

always @(posedge CLKOUT, posedge reset) begin
    if (reset) begin
        count <= 0;
        delay <= 0;
        ECHO <= 0;
    end else begin
        if (entrada) begin
            count <= count + 1;
            delay <= 10;
            ECHO <= 1;
        end else if (delay > 0) begin
            delay <= delay - 1;
            ECHO <= 1;
        end else begin
            ECHO <= 0;
        end
    end
end

endmodule