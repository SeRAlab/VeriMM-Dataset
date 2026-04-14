module sr_flip_flop (  
    input wire Set,  
    input wire Reset,  
    input wire clk,  
    output reg Q,  
    output reg Q_bar  
);  
    always @(posedge clk or posedge Set or posedge Reset) begin  
        if (Set) begin  
            Q <= 1;  
            Q_bar <= 0;  
        end else if (Reset) begin  
            Q <= 0;  
            Q_bar <= 1;  
        end  
    end  
endmodule