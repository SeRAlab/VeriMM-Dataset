module top_module(
    input CLK,
    input RST,
    input O_STB,
    input [4*8-1:0] O_DAT,
    output reg [7:0] COUNT
);reg [7:0] expected_data;
reg [7:0] data;
reg [2:0] error;
reg stb;
reg [31:0] data_out;

always @(posedge CLK) begin
    if (RST) begin
        COUNT <= 0;
        expected_data <= 8'h00;
        data <= 8'h00;
        error <= 0;
        stb <= 0;
        data_out <= 0;
    end else begin
        if (O_STB) begin
            data <= O_DAT[7:0];
            if (data == expected_data) begin
                expected_data <= {1'b0, expected_data[7:1]};
                stb <= 1;
                data_out <= {data_out[23:0], data};
            end else begin
                error <= error + 1;
                stb <= 0;
            end
        end else begin
            stb <= 0;
        end
        COUNT <= error;
    end
end

assign O_STB = stb;
assign O_DAT = data_out;

endmodule