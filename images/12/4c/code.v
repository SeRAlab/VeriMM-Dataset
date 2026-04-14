module deserializer_16bit (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire valid,  
    output reg [15:0] data_out  
);  
    reg [7:0] buffer;  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 16'b0;  
            buffer <= 8'b0;  
            state <= 2'b00;  
        end else if (valid) begin  
            case (state)  
                2'b00: begin  
                    buffer <= data_in;  
                    state <= 2'b01;  
                end  
                2'b01: begin  
                    data_out <= {data_in, buffer};  
                    state <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule