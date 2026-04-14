module top_module(
    Q      ,
    Q_N    ,
    D      ,
    CLK_N  ,
    SET_B  ,
    RESET_B
);// Module ports
    output reg  Q      ;
    output       Q_N    ;
    input        D      ;
    input        CLK_N  ;
    input        SET_B  ;
    input        RESET_B;

    // Local signals
    wire RESET          ;
    wire SET            ;
    wire CLK            ;

    // Asynchronous set and reset signals
    assign RESET = ~RESET_B;  // Active high
    assign SET = ~SET_B;      // Active high
    assign CLK = ~CLK_N;      // Inverted clock

    always @(posedge CLK or posedge SET or negedge RESET) begin
        if (SET) begin
            Q <= 1'b1;         // Set Q to 1
        end else if (~RESET) begin
            Q <= 1'b0;         // Reset Q to 0
        end else begin
            Q <= D;            // Update Q with D
        end
    end

    // Generate complementary output
    assign Q_N = ~Q;

endmodule