module mux5to1 (  
    input wire [4:0] in, // 5 input signals  
    input wire [2:0] sel, // 3-bit select line  
    output wire out // Output signal  
);  
    assign out = (sel == 3'b000) ? in[0] :  
                 (sel == 3'b001) ? in[1] :  
                 (sel == 3'b010) ? in[2] :  
                 (sel == 3'b011) ? in[3] :  
                 (sel == 3'b100) ? in[4] : 1'b0;  
endmodule