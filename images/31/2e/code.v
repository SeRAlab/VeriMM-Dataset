module round_robin_arbiter(  
    input clk,  
    input rst,  
    input [3:0] req,  
    output reg [3:0] grant  
);  
    reg [1:0] current; // to keep track of the current grant position  
    reg [3:0] pending; // pending requests  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
            current <= 2'b00;  
        end else begin  
            pending = req & ~grant; // check for active requests  
            if (pending) begin  
                grant <= (1 << current) & pending; // grant the current request  
            end else begin  
                grant <= 4'b0000; // no grant if no pending requests  
            end  

            current <= (current + 1) % 4; // move to the next request  
        end  
    end  
endmodule