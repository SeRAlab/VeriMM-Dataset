module pipelined_processor (  
    input clk,  
    input rst,  
    input [7:0] a,  
    input [7:0] b,  
    input start,  
    output reg [7:0] result,  
    output reg done  
);  
    reg [7:0] IF_a, IF_b;  
    reg [7:0] ID_a, ID_b;  
    reg [7:0] EX_result;  
    reg [2:0] state;  // 0: IF, 1: ID, 2: EX, 3: MEM, 4: WB  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 0;  
            done <= 0;  
            result <= 0;  
        end else begin  
            case (state)  
                0: begin  // IF  
                    if (start) begin  
                        IF_a <= a;  
                        IF_b <= b;  
                        state <= 1;  
                    end  
                end  
                1: begin  // ID  
                    ID_a <= IF_a;  
                    ID_b <= IF_b;  
                    state <= 2;  
                end  
                2: begin  // EX  
                    EX_result <= ID_a + ID_b;  
                    state <= 3;  
                end  
                3: begin  // MEM  
                    // No memory operation in this example  
                    state <= 4;  
                end  
                4: begin  // WB  
                    result <= EX_result;  
                    done <= 1;  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule