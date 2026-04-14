module pcie_endpoint_controller(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] new_status,  
    output reg [7:0] status  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            status <= 8'b0;  
        end else begin  
            status <= new_status;  
        end  
    end  
endmodule