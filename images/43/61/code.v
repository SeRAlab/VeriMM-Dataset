module top_module(
    input clk, 
    input [1:0] varDelay,  
    input [11:0] MIC_in, 
    output reg [11:0] SPEAKER_OUT, 
    output reg [6:0] seg 
    );reg [1:0] k;
    always @ (varDelay) begin 
        if (varDelay == 2'b00) k=2'b00; 
        else k=varDelay;
    end   
    
    reg [16:0]i = 0; 
    reg [11:0] memory [0:99999]; 
    
    always @ (posedge clk) begin
        i <= (i==99999)? 0 : i+1; 
        memory[(i+1+(20000*k))%100000] <= MIC_in;   
        SPEAKER_OUT <= memory[i];  
        
        case (k)
            0 : seg = 7'b1000000; 
            1 : seg = 7'b1111001; 
            2 : seg = 7'b0100100; 
            3 : seg = 7'b0110000; 
        endcase 
    end 
endmodule