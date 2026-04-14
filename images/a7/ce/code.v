module mux_2to1(A, B, sel, Y);
    input A;
    input B;
    input sel;
    output Y;

    reg Y;

    always @(A or B or sel) begin
        if (sel) begin
            Y = B;
        end else begin
            Y = A;
        end
    end
endmodule