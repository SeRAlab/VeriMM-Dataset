module comparator_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire eq,
    output wire lt,
    output wire gt
);

    wire eq1, eq2, lt1, lt2, gt1, gt2;

    comparator_16bit comp1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .eq(eq1),
        .lt(lt1),
        .gt(gt1)
    );

    comparator_16bit comp2 (
        .a(a[15:0]),
        .b(b[15:0]),
        .eq(eq2),
        .lt(lt2),
        .gt(gt2)
    );

    assign eq = eq1 & eq2;
    assign lt = lt1 | (eq1 & lt2);
    assign gt = gt1 | (eq1 & gt2);

endmodule

module comparator_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire eq,
    output wire lt,
    output wire gt
);

    wire eq1, eq2, lt1, lt2, gt1, gt2;

    comparator_8bit comp1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .eq(eq1),
        .lt(lt1),
        .gt(gt1)
    );

    comparator_8bit comp2 (
        .a(a[7:0]),
        .b(b[7:0]),
        .eq(eq2),
        .lt(lt2),
        .gt(gt2)
    );

    assign eq = eq1 & eq2;
    assign lt = lt1 | (eq1 & lt2);
    assign gt = gt1 | (eq1 & gt2);

endmodule

module comparator_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire eq,
    output wire lt,
    output wire gt
);

    assign eq = (a == b);
    assign lt = (a < b);
    assign gt = (a > b);

endmodule