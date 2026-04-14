module pll_4x (  
    input wire clk_in,  
    input wire reset_n,  
    input wire enable,  
    output reg clk_out_0,  
    output reg clk_out_1,  
    output reg clk_out_2,  
    output reg clk_out_3  
);  
    reg [1:0] state;  
    always @(posedge clk_in or negedge reset_n) begin  
        if (!reset_n) begin  
            clk_out_0 <= 0;  
            clk_out_1 <= 0;  
            clk_out_2 <= 0;  
            clk_out_3 <= 0;  
            state <= 2'b00;  
        end else if (enable) begin  
            case (state)  
                2'b00: begin  
                    clk_out_0 <= ~clk_out_0;  
                    state <= 2'b01;  
                end  
                2'b01: begin  
                    clk_out_1 <= ~clk_out_1;  
                    state <= 2'b10;  
                end  
                2'b10: begin  
                    clk_out_2 <= ~clk_out_2;  
                    state <= 2'b11;  
                end  
                2'b11: begin  
                    clk_out_3 <= ~clk_out_3;  
                    state <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule