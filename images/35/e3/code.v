module clock_divider(  
    input wire clk,  
    input wire enable,  
    output reg div_clk  
);  
    reg [1:0] counter;  

    always @(posedge clk) begin  
        if (enable) begin  
            counter <= counter + 1;  
            if (counter == 2'b01)  
                div_clk <= ~div_clk;  
        end  
        else begin  
            div_clk <= 0;  
            counter <= 0;  
        end  
    end  
endmodule