module my_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    output reg X
);

    reg [31:0] T, T2;

    always @(*) begin
        if (A == 0) begin
            X = 0;
        end else begin
            T = B + C;
            if (T >= D) begin
                X = 1;
            end else begin
                T2 = E + T;
                if (T2 >= D) begin
                    X = 1;
                end else begin
                    X = 0;
                end
            end
        end
    end

endmodule