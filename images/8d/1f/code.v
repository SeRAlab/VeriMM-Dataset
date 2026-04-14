module debounce(
    input       clk,
    input       rst_n,
    input       btn_in,
    output reg  btn_out
);

    reg [3:0] counter;
    reg btn_in_d;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= 4'b0;
            btn_out <= 1'b0;
            btn_in_d <= 1'b0;
        end
        else begin
            if(btn_in == btn_in_d) begin
                if(counter < 4'd10) begin
                    counter <= counter + 1;
                end
                else begin
                    btn_out <= btn_in;
                end
            end
            else begin
                counter <= 4'b0;
            end
            btn_in_d <= btn_in;
        end
    end

endmodule