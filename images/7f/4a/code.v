module top_module(
    input  wire        CLK,
    input  wire        RST,
    input  wire [ 8:0] A,
    input  wire [ 8:0] B,
    output reg [17:0] Z
);reg [8:0] ra;
    always @(posedge CLK) begin
        if (RST) 
            ra <= 0;
        else     
            ra <= A;
    end

    // Instantiate a behavioral multiply for 9x9 bit multiplication
    always @(posedge CLK) begin
        if (RST) 
            Z <= 0;
        else 
            Z <= ra * B;  // Perform multiplication
    end

endmodule