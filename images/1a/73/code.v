module nvme_controller(  
    input wire clk,  
    input wire enable,  
    input wire wr,  
    input wire rd,  
    input wire [31:0] data_in,  
    output reg [31:0] data_out  
);  
    reg [31:0] register;  
  
    always @(posedge clk) begin  
        if (enable) begin  
            if (wr) begin  
                register <= data_in;  
            end  
            if (rd) begin  
                data_out <= register;  
            end  
        end  
    end  
endmodule