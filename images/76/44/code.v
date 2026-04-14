module top_module(
    input  wire        CLK,
    input  wire        RST,
    input  wire [ 8:0] A,
    input  wire [ 8:0] B,
    output reg [17:0] Z
);reg [8:0] ra;
    
    // Register A on rising clock edge or reset line
    always @(posedge CLK or posedge RST)
        if (RST) ra <= 0;
        else     ra <= A;

    // Instantiate a behavioral multiplier if the MULT9X9 module is unavailable
    always @(posedge CLK or posedge RST) begin
        if (RST) 
            Z <= 0;
        else 
            Z <= ra * B; // Use simple multiplication instead
    end

endmodule