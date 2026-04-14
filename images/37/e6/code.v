module pipeline_processor(  
    input clk,  
    input rst,  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] result  
);  
    reg [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;  
    reg [2:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 0;  
            result <= 0;  
        end else begin  
            case (state)  
                3'b000: begin // Fetch  
                    stage1 <= A;  
                    stage2 <= B;  
                    state <= state + 1;  
                end  
                3'b001: begin // Decode  
                    stage3 <= stage1;  
                    stage4 <= stage2;  
                    state <= state + 1;  
                end  
                3'b010: begin // Execute  
                    stage5 <= stage3 + stage4;  
                    state <= state + 1;  
                end  
                3'b011: begin // Memory Access (not used, just passing through)  
                    stage6 <= stage5;  
                    state <= state + 1;  
                end  
                3'b100: begin // Write Back  
                    result <= stage6;  
                    state <= 0; // Start over for the next operation  
                end  
                default: state <= 0;  
            endcase  
        end  
    end  
endmodule