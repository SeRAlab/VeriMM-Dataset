module pulse_generator(
    input               clk         ,   
    input               rst         ,
    input               start       ,
    input       [7:0]   pulse_width ,
 
    output  reg         pulse_out
);

    reg [7:0] counter;
    reg active;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            pulse_out <= 0;
            active <= 0;
        end
        else begin
            if (start && !active) begin
                active <= 1;
                counter <= pulse_width;
                pulse_out <= 1;
            end
            else if (active) begin
                if (counter == 0) begin
                    active <= 0;
                    pulse_out <= 0;
                end
                else begin
                    counter <= counter - 1;
                end
            end
        end
    end

endmodule