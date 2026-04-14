module top_module(clk, reset, toPCInc, toPC, toIR, PCInc, PC, IR, tofirst_multiple, first_multiple, flush);// First pipeline register

    output first_multiple;
    output [15:0] PCInc, PC, IR;
    input  [15:0] toPCInc, toPC, toIR;
    input        reset, clk;
    input tofirst_multiple, flush;
    wire [15:0] inIR;
    wire infirst_multiple;

    assign infirst_multiple = (flush == 1'b1) ? 1'b0 : tofirst_multiple; // introduce a NOP, in the event of a flush
    assign inIR = (flush == 1'b1) ? 16'b1111000000000000 : toIR; // introduce a NOP, in the event of a flush

    // Assuming the following simple register modules for register1 and register16
    reg first_multiple_reg;
    reg [15:0] PCInc_reg, PC_reg, IR_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            first_multiple_reg <= 1'b0;
            PCInc_reg <= 16'b0;
            PC_reg <= 16'b0;
            IR_reg <= 16'b0;
        end else begin
            first_multiple_reg <= infirst_multiple;
            PCInc_reg <= toPCInc;
            PC_reg <= toPC;
            IR_reg <= inIR;
        end
    end

    assign first_multiple = first_multiple_reg;
    assign PCInc = PCInc_reg;
    assign PC = PC_reg;
    assign IR = IR_reg;

endmodule