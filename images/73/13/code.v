module top_module(
    Y   ,
    A   ,
    VPWR,
    VGND,
    clk  // Adding clk as an input port
);output Y   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  clk; // Declare clk as an input

    reg [4:0] delay_reg; // register to hold delayed signal
    reg out_reg; // register to hold output signal

    always @(posedge clk) begin
        delay_reg <= {delay_reg[3:0], A}; // shift in new input bit
        out_reg <= delay_reg[4]; // output delayed signal
    end

    assign Y = out_reg;

endmodule