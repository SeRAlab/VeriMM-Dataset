module pipeline_adder(  
    input clk,  
    input rst_n,  
    input [7:0] a,  
    input [7:0] b,  
    input valid,  
    output reg [8:0] sum,  
    output reg ready  
);  
    reg [7:0] a_reg, b_reg;  
    reg valid_reg;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            a_reg <= 0;  
            b_reg <= 0;  
            valid_reg <= 0;  
            sum <= 0;  
            ready <= 0;  
        end else begin  
            if (valid) begin  
                a_reg <= a;  
                b_reg <= b;  
                valid_reg <= 1;  
            end  
            if (valid_reg) begin  
                sum <= a_reg + b_reg;  
                ready <= 1;  
                valid_reg <= 0;  
            end else begin  
                ready <= 0;  
            end  
        end  
    end  
endmodule