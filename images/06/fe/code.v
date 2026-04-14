module pcie_endpoint_controller(  
    input wire clk,  
    input wire read_req,  
    output reg [31:0] data_out  
);  
    always @(posedge clk) begin  
        if (read_req) begin  
            data_out <= 32'hDEADBEEF; // Fixed data value  
        end  
    end  
endmodule