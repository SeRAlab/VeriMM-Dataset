module shift_register_8bit(clk, reset, data_in, load, direction, data_out);
    input clk;
    input reset;
    input [7:0] data_in;
    input load;
    input direction;
    output [7:0] data_out;
    reg [7:0] data_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000;
        end
        else if (load) begin
            data_out <= data_in;
        end
        else begin
            if (direction) begin
                data_out <= data_out << 1;
            end
            else begin
                data_out <= data_out >> 1;
            end
        end
    end
endmodule