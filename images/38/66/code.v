module dma_controller (
    input clk,
    input rst,
    input [1:0] channel_select,
    input [15:0] mem_address_in,
    input [15:0] data_in,
    output reg [15:0] mem_address_out,
    output reg [15:0] data_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_address_out <= 16'b0;
            data_out <= 16'b0;
        end else begin
            case (channel_select)
                2'b00: begin
                    mem_address_out <= mem_address_in;
                    data_out <= data_in;
                end
                2'b01: begin
                    mem_address_out <= mem_address_in + 16'h1000;
                    data_out <= data_in + 16'h10;
                end
                2'b10: begin
                    mem_address_out <= mem_address_in + 16'h2000;
                    data_out <= data_in + 16'h20;
                end
                2'b11: begin
                    mem_address_out <= mem_address_in + 16'h3000;
                    data_out <= data_in + 16'h30;
                end
                default: begin
                    mem_address_out <= 16'b0;
                    data_out <= 16'b0;
                end
            endcase
        end
    end
endmodule