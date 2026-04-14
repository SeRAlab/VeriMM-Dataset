module phase_detector (  
    input [1:0] a,  
    input [1:0] b,  
    output reg [1:0] phase_diff  
);  
    always @(*) begin  
        if (a == b)  
            phase_diff = 2'b00; // 0 cycles  
        else if ({a[0], a[1]} == {b[1], b[0]})  
            phase_diff = 2'b01; // 1 cycle  
        else if ({a[1], a[0]} == {b[0], b[1]})  
            phase_diff = 2'b10; // 2 cycles  
        else  
            phase_diff = 2'b11; // invalid  
    end  
endmodule