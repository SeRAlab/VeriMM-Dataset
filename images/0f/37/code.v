module phase_detector (  
    input wire A,  
    input wire B,  
    output wire Out  
);  
    assign Out = (A == B) ? 1'b1 : 1'b0;  
endmodule