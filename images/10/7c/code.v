module arq_system(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] data_in,  
    input wire valid,  
    output reg ack,  
    output reg [3:0] data_out  
);  
    reg [3:0] received_data;  
    reg error;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ack <= 0;  
            received_data <= 4'b0000;  
            data_out <= 4'b0000;  
        end else begin  
            if (valid) begin  
                received_data <= data_in;  
                error <= (data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3]); // Simple parity check  
                if (error) begin  
                    ack <= 0;  
                end else begin  
                    ack <= 1;  
                    data_out <= received_data;  
                end  
            end  
        end  
    end  
endmodule