module top_module(
    input CLK,
    input RST,
    input CLR,
    input LD,
    input [3:0] DATA,
    output reg [4:0] Q
);reg [3:0] binary_counter;
reg [3:0] async_counter;

always @(posedge CLK) begin
    if (RST) begin
        binary_counter <= 4'b0000;
    end else begin
        binary_counter <= binary_counter + 1;
    end
end

always @(posedge CLK) begin
    if (CLR) begin
        async_counter <= 4'b0000;
    end else if (LD) begin
        async_counter <= DATA;
    end else begin
        async_counter <= async_counter + 1;
    end
end

always @* begin
    Q = binary_counter + async_counter;
end

endmodule