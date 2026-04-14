module top_module(
    Q  ,
    CLK,
    D  ,
    SCD,
    SCE
);// Module ports
    output Q  ;
    input  CLK;
    input  D  ;
    input  SCD;
    input  SCE;

    // Local signals
    wire buf_Q  ;
    wire mux_out;

    // 2-to-1 multiplexer (using a behavioral description)
    assign mux_out = (SCE) ? SCD : D;  // Conditional assignment to mimic multiplexer behavior

    // D flip-flop (using a behavioral description)
    reg buf_Q_reg;                       // Declare a register for the D flip-flop

    always @(posedge CLK) begin
        buf_Q_reg <= mux_out;           // D flip-flop behavior
    end

    assign buf_Q = buf_Q_reg;           // Assigning register value to wire

    // Buffer
    buf buf0 (Q, buf_Q);

endmodule