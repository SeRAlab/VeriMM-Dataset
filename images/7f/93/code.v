module top_module(
    input lrck,
    input reset,
    input [2:0] sound_code,
    output reg [15:0] left_data,
    output reg [15:0] right_data
);reg [15:0] sound_data [0:7];
    integer i;

    // Initialize sound data for each sound code
    initial begin
        sound_data[0] = 16'h0000;
        sound_data[1] = 16'h7FFF;
        sound_data[2] = 16'h8000;
        sound_data[3] = 16'hFFFF;
        sound_data[4] = 16'h5555;
        sound_data[5] = 16'hAAAA;
        sound_data[6] = 16'hCCCC;
        sound_data[7] = 16'h3333;
    end

    always @ (posedge lrck) begin
        if (reset) begin
            left_data <= 16'h0000;
            right_data <= 16'h0000;
        end else begin
            left_data <= sound_data[sound_code][7:0];
            right_data <= sound_data[sound_code][15:8];
        end
    end

endmodule