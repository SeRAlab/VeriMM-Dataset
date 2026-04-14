module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [49:0] in,
    output reg [5:0] q,
    output reg [3:0] count
);reg [49:0] rotated_data;
reg [49:0] shifted_data;
reg [55:0] sum;
reg [5:0] multiplier;

always @(posedge clk) begin
    if (load) begin
        multiplier <= 6'b000001;
        count <= 4'b0000;
    end else begin
        count <= count + 1;
        if (ena[0]) begin
            rotated_data <= {in[0], in[49:1]};
        end else if (ena[1]) begin
            rotated_data <= {in[48:0], in[49]};
        end
        shifted_data <= {rotated_data[5:0], rotated_data};
        sum <= in + shifted_data;
        multiplier <= sum[55:50] * rotated_data[55:50];
        q <= multiplier[5:0];
    end
end

endmodule