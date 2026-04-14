module mux_2to1_with_forwarding(  
    input [3:0] in0,  
    input [3:0] in1,  
    input sel,  
    input forward,  
    output reg [3:0] out  
);  
    always @(*) begin  
        if (forward)  
            out = out;  // forward the previous output  
        else  
            out = (sel) ? in0 : in1;  // select input based on sel  
    end  
endmodule