module mux8to1 (  
    input wire [7:0] in, // 8 input lines  
    input wire [2:0] sel, // 3 selection lines  
    output wire out // single output line  
);  
    assign out = in[sel];  
endmodule