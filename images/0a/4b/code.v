module dma_controller (
    input wire start,
    input wire [1:0] channel_select,
    input wire [15:0] mem_address,
    input wire [15:0] peripheral_data,
    output reg [15:0] mem_out,
    output reg done
);
    reg [15:0] peripheral_data_reg [0:3];
    
    always @(posedge start) begin
        case (channel_select)
            2'b00: peripheral_data_reg[0] <= peripheral_data;
            2'b01: peripheral_data_reg[1] <= peripheral_data;
            2'b10: peripheral_data_reg[2] <= peripheral_data;
            2'b11: peripheral_data_reg[3] <= peripheral_data;
            default: ;
        endcase
        mem_out <= peripheral_data_reg[channel_select];
        done <= 1'b1;
    end
endmodule