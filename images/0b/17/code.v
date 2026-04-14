module nat_device (  
    input clk,  
    input reset,  
    input [7:0] internal_addr,  
    input [7:0] external_addr,  
    input send_internal,  
    input send_external,  
    output reg [7:0] translated_addr  
);  

    reg [7:0] internal_to_external[0:4];  
    reg [7:0] external_to_internal[0:4];  
    reg [2:0] internal_index;  
    reg [2:0] external_index;  

    initial begin  
        // Initialize mappings (for example purposes)  
        internal_to_external[0] = 8'hC0; // 192  
        internal_to_external[1] = 8'hC1; // 193  
        internal_to_external[2] = 8'hC2; // 194  
        internal_to_external[3] = 8'hC3; // 195  
        internal_to_external[4] = 8'hC4; // 196  
      
        external_to_internal[0] = 8'hA0; // 160  
        external_to_internal[1] = 8'hA1; // 161  
        external_to_internal[2] = 8'hA2; // 162  
        external_to_internal[3] = 8'hA3; // 163  
        external_to_internal[4] = 8'hA4; // 164  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            translated_addr <= 8'h00;  
        end else begin  
            if (send_internal) begin  
                internal_index = internal_addr - 8'hC0; // Assuming 192, 193, 194, 195, 196 are internal  
                translated_addr <= internal_to_external[internal_index];  
            end else if (send_external) begin  
                external_index = external_addr - 8'hA0; // Assuming 160, 161, 162, 163, 164 are external  
                translated_addr <= external_to_internal[external_index];  
            end  
        end  
    end  
endmodule