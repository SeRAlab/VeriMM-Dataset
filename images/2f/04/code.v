module phase_detector (  
    input wire clk,  
    input wire A,  
    input wire B,  
    output reg [1:0] phase_status  
);  
    reg A_prev;  
    reg B_prev;  

    always @(posedge clk) begin  
        A_prev <= A;  
        B_prev <= B;  
        
        if (A_prev && ~B_prev)  
            phase_status <= 2'b01; // A leads B  
        else if (~A_prev && B_prev)  
            phase_status <= 2'b10; // A lags B  
        else  
            phase_status <= 2'b00; // A is in phase with B  
    end  
endmodule