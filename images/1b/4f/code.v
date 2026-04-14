module pipeline_adder (  
    input clk,  
    input reset,  
    input [31:0] a,  
    input [31:0] b,  
    output reg [31:0] result  
);  
    reg [31:0] IF_a, IF_b;  
    reg [31:0] ID_a, ID_b;  
    reg [31:0] EX_sum;  

    // Stage 1: Instruction Fetch  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_a <= 0;  
            IF_b <= 0;  
        end else begin  
            IF_a <= a;  
            IF_b <= b;  
        end  
    end  
    
    // Stage 2: Instruction Decode  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ID_a <= 0;  
            ID_b <= 0;  
        end else begin  
            ID_a <= IF_a;  
            ID_b <= IF_b;  
        end  
    end  
    
    // Stage 3: Execute  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            EX_sum <= 0;  
        end else begin  
            EX_sum <= ID_a + ID_b;  
        end  
    end  
    
    // Stage 4: Memory Access (no operation here, just pass through)  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            result <= 0;  
        end else begin  
            result <= EX_sum;  
        end  
    end  
endmodule