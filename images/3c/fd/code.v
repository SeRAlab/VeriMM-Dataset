module pcie_controller (  
    input wire clk,  
    input wire read_req,  
    input wire [3:0] address,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:15];  

    initial begin  
        // Initialize memory with some values  
        memory[0] = 8'hA0;  
        memory[1] = 8'hB1;  
        memory[2] = 8'hC2;  
        memory[3] = 8'hD3;  
        memory[4] = 8'hE4;  
        memory[5] = 8'hF5;  
        memory[6] = 8'h12;  
        memory[7] = 8'h34;  
        memory[8] = 8'h56;  
        memory[9] = 8'h78;  
        memory[10] = 8'h9A;  
        memory[11] = 8'hBC;  
        memory[12] = 8'hDE;  
        memory[13] = 8'hF0;  
        memory[14] = 8'h11;  
        memory[15] = 8'h22;  
    end  

    always @(posedge clk) begin  
        if (read_req) begin  
            data_out <= memory[address];  
        end  
    end  
endmodule