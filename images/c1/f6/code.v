module binary_counter (
    clock,
    load,
    data_in,
    count
);

input clock;
input load;
input [3:0] data_in;
output reg [3:0] count;

always @(posedge clock) begin
    if (load) begin
        count <= data_in;
    end else if (count == 4'b1111) begin
        count <= 4'b0000;
    end else begin
        count <= count + 1;
    end
end

endmodule