module mux8to1(  
    input wire [7:0] data,  
    input wire [2:0] sel,  
    output wire y  
);  
    assign y = (sel == 3'b000) ? data[0] :  
               (sel == 3'b001) ? data[1] :  
               (sel == 3'b010) ? data[2] :  
               (sel == 3'b011) ? data[3] :  
               (sel == 3'b100) ? data[4] :  
               (sel == 3'b101) ? data[5] :  
               (sel == 3'b110) ? data[6] :  
               data[7];  
endmodule