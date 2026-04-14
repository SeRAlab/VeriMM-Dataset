module bus_driver(
    input A,
    output reg Z,
    input TE_B,
    input SLEEP
);

    always @(*) begin
        if (SLEEP) begin
            Z <= 1'b0;
        end else if (TE_B) begin
            Z <= A;
        end
    end

endmodule