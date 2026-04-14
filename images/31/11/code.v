module pipeline_adder (  
    input clk,  
    input reset,  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] result  
);  

    reg [7:0] IF_A, IF_B;  
    reg [7:0] ID_A, ID_B;  
    reg [7:0] EX_sum;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_A <= 0;  
            IF_B <= 0;  
            ID_A <= 0;  
            ID_B <= 0;  
            EX_sum <= 0;  
            result <= 0;  
        end else begin  
            // Instruction Fetch Stage  
            IF_A <= A;  
            IF_B <= B;  

            // Instruction Decode Stage  
            ID_A <= IF_A;  
            ID_B <= IF_B;  

            // Execute Stage  
            EX_sum <= ID_A + ID_B;  

            // Memory Access Stage (not used here, just pass-through)  

            // Write Back Stage  
            result <= EX_sum;  
        end  
    end  
endmodule