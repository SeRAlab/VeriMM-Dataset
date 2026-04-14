module crc_generator (  
    input  [3:0] data_in,  
    input  [2:0] poly,  
    output reg [2:0] crc_out,  
    input clk,  
    input reset  
);  
    reg [3:0] data;  
    reg [2:0] crc;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 3'b000;  
        end else begin  
            data <= data_in;  
            crc = data[3:1] ^ (poly & {data[3:1], 1'b0});  
            for (i = 0; i < 3; i = i + 1) begin  
                crc <= {crc[1:0], data[0]} ^ (poly & {1'b0, crc[2]});  
                data <= {1'b0, data[3:1]};  
            end  
        end  
    end  

    always @(posedge clk) begin  
        crc_out <= crc;  
    end  
endmodule