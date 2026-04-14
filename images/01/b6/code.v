module serializer_32bit (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    output reg [31:0] data_out  
);  
    reg [1:0] state;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 32'b0;  
            shift_reg <= 8'b0;  
            state <= 2'b00;  
        end else begin  
            case (state)  
                2'b00: begin  
                    shift_reg <= data_in;  
                    state <= 2'b01;  
                end  
                2'b01: begin  
                    data_out <= {data_out[23:0], shift_reg[7:0]};  
                    state <= 2'b10;  
                end  
                2'b10: begin  
                    data_out <= {data_out[15:0], shift_reg[7:0]};  
                    state <= 2'b11;  
                end  
                2'b11: begin  
                    data_out <= {data_out[7:0], shift_reg[7:0]};  
                    state <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule