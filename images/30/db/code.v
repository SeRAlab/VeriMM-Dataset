module ethernet_mac_controller (  
    input wire clk,  
    input wire reset,  
    input wire valid,  
    input wire [7:0] data_in,  
    output reg data_out,  
    output reg error  
);  
    reg [7:0] buffer;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            buffer <= 8'b0;  
            data_out <= 1'b0;  
            error <= 1'b0;  
        end else if (valid) begin  
            buffer <= data_in;  
            // Simple error check: if data_in has a specific value, it's an error  
            if (data_in == 8'hFF) begin  
                error <= 1'b1;  
                data_out <= 1'b0;  
            end else begin  
                error <= 1'b0;  
                data_out <= 1'b1;  
            end  
        end  
    end  
endmodule