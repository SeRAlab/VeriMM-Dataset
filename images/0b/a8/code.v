module dma_controller(  
    input wire clk,  
    input wire start,  
    input wire [2:0] channel_sel,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg busy  
);  

    reg [7:0] channels [0:7]; // 8-channel storage  

    always @(posedge clk) begin  
        if (start) begin  
            busy <= 1;  
            channels[channel_sel] <= data_in; // Store incoming data  
        end  

        if (busy) begin  
            data_out <= channels[channel_sel]; // Output data from the selected channel  
            busy <= 0; // Transfer complete  
        end  
    end  
endmodule