module top_module(
    input [255:0] in,
    input [7:0] sel,
    output reg out
);reg [255:0] temp [0:127];

integer i;

always @* begin
    for (i = 0; i < 256; i = i + 2) begin
        temp[i/2] = (sel[7] == 0) ? in[i] : in[i+1];
    end
end

always @* begin
    for (i = 0; i < 128; i = i + 2) begin
        temp[i/2] = (sel[6] == 0) ? temp[i] : temp[i+1];
    end
end

always @* begin
    for (i = 0; i < 64; i = i + 2) begin
        temp[i/2] = (sel[5] == 0) ? temp[i] : temp[i+1];
    end
end

always @* begin
    for (i = 0; i < 32; i = i + 2) begin
        temp[i/2] = (sel[4] == 0) ? temp[i] : temp[i+1];
    end
end

always @* begin
    for (i = 0; i < 16; i = i + 2) begin
        temp[i/2] = (sel[3] == 0) ? temp[i] : temp[i+1];
    end
end

always @* begin
    for (i = 0; i < 8; i = i + 2) begin
        temp[i/2] = (sel[2] == 0) ? temp[i] : temp[i+1];
    end
end

always @* begin
    for (i = 0; i < 4; i = i + 2) begin
        temp[i/2] = (sel[1] == 0) ? temp[i] : temp[i+1];
    end
end

always @* begin
    for (i = 0; i < 2; i = i + 2) begin
        temp[i/2] = (sel[0] == 0) ? temp[i] : temp[i+1];
    end
end

assign out = temp[0];

endmodule