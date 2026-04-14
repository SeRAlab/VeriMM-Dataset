module top_module(input clk,
                     output reg red,
                     output reg yellow,
                     output reg green);reg [5:0] count; // counter to keep track of time
    reg [1:0] state; // state variable to keep track of traffic light state
    
    // initialization
    initial begin
        count = 0;
        state = 2'b10;
        red = 1'b1;
        yellow = 1'b0;
        green = 1'b0;
    end
    
    always @(posedge clk) begin
        // increment counter every 20ns (50 MHz clock)
        count <= count + 1;
        
        // state machine to control traffic light sequence
        case (state)
            2'b00: begin // red light
                if (count == 100_000_000) begin // 10 seconds
                    count <= 0;
                    state <= 2'b01;
                    red <= 1'b0;
                    yellow <= 1'b1;
                end
            end
            2'b01: begin // yellow light
                if (count == 20_000_000) begin // 2 seconds
                    count <= 0;
                    state <= 2'b10;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
            end
            2'b10: begin // green light
                if (count == 100_000_000) begin // 10 seconds
                    count <= 0;
                    state <= 2'b11;
                    green <= 1'b0;
                    yellow <= 1'b1;
                end
            end
            2'b11: begin // yellow light
                if (count == 20_000_000) begin // 2 seconds
                    count <= 0;
                    state <= 2'b00;
                    yellow <= 1'b0;
                    red <= 1'b1;
                end
            end
        endcase
    end
endmodule