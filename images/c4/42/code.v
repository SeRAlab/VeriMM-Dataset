module binary_ones_counter (
    input [15:0] data_in,
    output reg [3:0] ones_count
);

    integer i;
    reg [15:0] temp;

    always @ (data_in) begin
        temp = data_in;
        ones_count = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if (temp[0] == 1'b1) begin
                ones_count = ones_count + 1;
            end
            temp = temp >> 1;
        end
    end

endmodule