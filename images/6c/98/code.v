module top_module(
    output reg Q,
    input C, E, D
);// Initialize flip-flop
    always @ (posedge C) begin
        if (E) begin
            Q <= D;
        end
    end

    // Timing specifications for ICE40_HX
    `ifdef ICE40_HX
    specify
        $setup(D, posedge C &&& E, 470 - 449);
        $setup(E, posedge C, 0);
        if (E) (posedge C => (Q : D)) = 540;
    endspecify
    `endif

    // Timing specifications for ICE40_LP
    `ifdef ICE40_LP
    specify
        $setup(D, posedge C &&& E, 693 - 662);
        $setup(E, posedge C, 0);
        if (E) (posedge C => (Q : D)) = 796;
    endspecify
    `endif

    // Timing specifications for ICE40_U
    `ifdef ICE40_U
    specify
        $setup(D, posedge C &&& E, 0); // Negative times not currently supported
        $setup(E, posedge C, 0);
        if (E) (posedge C => (Q : D)) = 1391;
    endspecify
    `endif

endmodule