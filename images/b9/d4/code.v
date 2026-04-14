module top_module(input clk, input reset, input load, input direction, input serial_in, output reg [3:0] serial_out);reg [3:0] data;

always @(posedge clk) begin
    if(reset) begin
        data <= 4'b0000;
    end
    else if(load) begin
        data <= {3'b000, serial_in}; // Load serial_in into the least significant bit
    end
    else begin
        if(direction) begin
            data <= {data[2:0], data[3]}; // Shift right
        end
        else begin
            data <= {data[0], data[3:1]}; // Shift left
        end
    end
end

assign serial_out = data;

endmodule