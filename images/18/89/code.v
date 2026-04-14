module pcie_packet_counter(  
    input wire clk,  
    input wire reset,  
    input wire packet_valid,  
    output reg [7:0] packet_count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            packet_count <= 8'b0;  
        end else if (packet_valid) begin  
            packet_count <= packet_count + 1;  
        end  
    end  
endmodule