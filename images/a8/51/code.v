module comparator_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire eq,
    output wire gt,
    output wire lt
);

    wire eq0, eq1, eq2, eq3;
    wire gt0, gt1, gt2, gt3;
    wire lt0, lt1, lt2, lt3;

    comparator8 comparator8_inst0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .eq(eq0),
        .gt(gt0),
        .lt(lt0)
    );

    comparator8 comparator8_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .eq(eq1),
        .gt(gt1),
        .lt(lt1)
    );

    comparator8 comparator8_inst2 (
        .a(a[23:16]),
        .b(b[23:16]),
        .eq(eq2),
        .gt(gt2),
        .lt(lt2)
    );

    comparator8 comparator8_inst3 (
        .a(a[31:24]),
        .b(b[31:24]),
        .eq(eq3),
        .gt(gt3),
        .lt(lt3)
    );

    assign eq = eq0 & eq1 & eq2 & eq3;
    assign gt = gt0 | (eq0 & gt1) | (eq0 & eq1 & gt2) | (eq0 & eq1 & eq2 & gt3);
    assign lt = lt0 | (eq0 & lt1) | (eq0 & eq1 & lt2) | (eq0 & eq1 & eq2 & lt3);

endmodule

module comparator8 (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire eq,
    output wire gt,
    output wire lt
);
    assign eq = (a == b);
    assign gt = (a > b);
    assign lt = (a < b);
endmodule