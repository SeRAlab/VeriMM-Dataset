module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [7:0] in,
    input [99:0] data,
    output reg [7:0] out
);reg [99:0] shifted_data;
reg [7:0] priority_encoded;
reg [2:0] highest_bit_pos;

always @(posedge clk) begin
    if (load) begin
        shifted_data <= data;
    end else begin
        if (ena[0] && ena[1]) begin
            shifted_data <= {data[99], data[98:0]};
        end else if (ena[0]) begin
            shifted_data <= {data[98:0], data[99]};
        end else if (ena[1]) begin
            shifted_data <= {data[0], data[99:1]};
        end
    end
end

always @* begin
    priority_encoded = 8'b00000000;
    if (shifted_data[99]) begin
        priority_encoded = 8'b10000000;
        highest_bit_pos = 3'b111;
    end else if (shifted_data[98]) begin
        priority_encoded = 8'b01000000;
        highest_bit_pos = 3'b110;
    end else if (shifted_data[97]) begin
        priority_encoded = 8'b00100000;
        highest_bit_pos = 3'b101;
    end else if (shifted_data[96]) begin
        priority_encoded = 8'b00010000;
        highest_bit_pos = 3'b100;
    end else if (shifted_data[95]) begin
        priority_encoded = 8'b00001000;
        highest_bit_pos = 3'b011;
    end else if (shifted_data[94]) begin
        priority_encoded = 8'b00000100;
        highest_bit_pos = 3'b010;
    end else if (shifted_data[93]) begin
        priority_encoded = 8'b00000010;
        highest_bit_pos = 3'b001;
    end else if (shifted_data[92]) begin
        priority_encoded = 8'b00000001;
        highest_bit_pos = 3'b000;
    end
end

always @* begin
    out = priority_encoded | in;
end

endmodule