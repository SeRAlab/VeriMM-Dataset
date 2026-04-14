module top_module(
    Q      ,
    Q_N    ,
    RESET  ,
    D      ,
    GATE  
);// Module ports
    output reg Q      ;  // Make Q a reg to store state
    output Q_N        ;  // Q_N is inferred as wire, no need to declare reg
    input  RESET      ; 
    input  D          ;
    input  GATE       ;

    // Local signals
    wire GATE_INV;
    wire D_GATE;

    // Invert GATE
    not GATE_INV_inst(GATE_INV, GATE);

    // State for feedback
    reg Q_INV;

    // Reset
    always @(posedge RESET) begin
        Q <= 0;
    end

    // Combinational logic for D and GATE
    always @(*) begin
        if (GATE) begin
            Q <= D;  // assign D to Q when GATE is high.
        end
        // No need for else condition as Q retains its value when GATE is low.
    end

    // Output complement
    assign Q_N = ~Q;

endmodule