module pcie_endpoint_controller(  
    input wire clk,  
    input wire rst_n,  
    input wire read_req,  
    input wire write_req,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg read_ack,  
    output reg write_ack  
);  
    reg [7:0] memory [0:255];  
    reg [7:0] address;  
    
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            read_ack <= 0;  
            write_ack <= 0;  
            data_out <= 0;  
        end else begin  
            if (write_req) begin  
                memory[address] <= data_in;  
                write_ack <= 1;  
            end else begin  
                write_ack <= 0;  
            end
            
            if (read_req) begin  
                data_out <= memory[address];  
                read_ack <= 1;  
            end else begin  
                read_ack <= 0;  
            end  
        end  
    end  
endmodule