module dma_controller (
    input clk,
    input start,
    input ch0,
    input ch1,
    input ch2,
    input ch3,
    output reg [1:0] active_channel,
    output reg transfer_done
);
    reg [7:0] address;
    parameter ADDRESS_LIMIT = 8'hFF;
    
    always @(posedge clk) begin
        if (start) begin
            if (ch0) active_channel <= 2'b00;
            else if (ch1) active_channel <= 2'b01;
            else if (ch2) active_channel <= 2'b10;
            else if (ch3) active_channel <= 2'b11;
            
            if (address < ADDRESS_LIMIT) begin
                address <= address + 1;
                transfer_done <= 0;
            end else begin
                transfer_done <= 1;
            end
        end else begin
            transfer_done <= 0;
            address <= 0; // Reset address when not starting
        end
    end
endmodule