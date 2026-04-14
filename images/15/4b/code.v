module pcie_endpoint_controller(  
    input wire clk,  
    input wire req,  
    output reg resp  
);  
    reg req_d;  
    always @(posedge clk) begin  
        req_d <= req;  
        if (req_d && !req) begin  
            resp <= 1;  
        end else begin  
            resp <= 0;  
        end  
    end  
endmodule