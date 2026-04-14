module interrupt_controller(  
    input wire clk,  
    input wire rst,  
    input wire int_req,  
    input wire enable,  
    output reg int_active  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            int_active <= 0;  
        else if (enable)  
            int_active <= int_active | int_req;  
        else  
            int_active <= 0;  
    end  
endmodule