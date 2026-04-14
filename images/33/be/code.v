module pipelined_adder (  
    input clk,  
    input rst,  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] result  
);  

    reg [7:0] if_reg_a, if_reg_b;  
    reg [7:0] id_reg_a, id_reg_b;  
    reg [7:0] ex_sum;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            result <= 8'b0;  
            if_reg_a <= 8'b0;  
            if_reg_b <= 8'b0;  
            id_reg_a <= 8'b0;  
            id_reg_b <= 8'b0;  
            ex_sum <= 8'b0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            if_reg_a <= a;  
            if_reg_b <= b;  

            // Stage 2: Instruction Decode  
            id_reg_a <= if_reg_a;  
            id_reg_b <= if_reg_b;  

            // Stage 3: Execute  
            ex_sum <= id_reg_a + id_reg_b;  

            // Stage 4: Memory Access (not used here, just pass through)  
            // Stage 5: Write Back  
            result <= ex_sum;  
        end  
    end  
endmodule