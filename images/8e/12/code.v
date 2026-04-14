module top_module(
    output reg [7:0] osizedreg,
    output reg oonewire,
    input [7:0] isizedwire,
    input ionewire
);reg [7:0] counter = 8'd0;

    always @(*) begin
        if(ionewire) begin
            counter <= isizedwire;
            oonewire <= 1'b1;
        end
        else begin
            if(counter > 8'd0) begin
                counter <= counter - 1;
                oonewire <= 1'b1;
            end
            else begin
                oonewire <= 1'b0;
            end
        end
    end

    always @(*) begin
        if(counter > 8'd0) begin
            osizedreg <= counter - 1;
        end
        else begin
            osizedreg <= 8'd0;
        end
    end

endmodule