module top_module(SW , CLOCK_50 , LEDR );input [7:0] SW;
    input CLOCK_50;

    
    output reg [7:0] LEDR;

    always @(posedge CLOCK_50)
        LEDR [7:0] <= SW [7:0];

endmodule