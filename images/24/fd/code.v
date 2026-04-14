module fixed_priority_arbiter(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] req,  
    output reg [3:0] grant  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
        end else begin  
            case (1)  
                // Priority for req[3] highest, req[0] lowest  
                req[3]: grant <= 4'b1000;  
                req[2]: grant <= 4'b0100;  
                req[1]: grant <= 4'b0010;  
                req[0]: grant <= 4'b0001;  
                default: grant <= 4'b0000;  
            endcase  
        end  
    end  
endmodule