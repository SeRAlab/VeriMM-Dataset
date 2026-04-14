module top_module(clock, reset, enable,
                       data, count, sclk, sdo, done,
                       spiclockp, spiclockn, picready, starting);input clock, spiclockp, spiclockn;
    input reset;
    input [127:0] data;
    input [4:0] count;
    input       enable, picready;

    output      sclk, sdo, done, starting;

    wire   clock, spiclockp, spiclockn;
    wire   enable;
    wire [127:0] data;
    wire [4:0]   count;
    reg          sclk, starting;
    wire         sdo, picready;

    reg [127:0]  latch;
    reg [7:0]    left;

    reg          ready, transmit_next;
    wire         done, transmitting;

    always @(posedge clock or negedge reset)
      if (~reset)
        begin
           ready <= 1;
           left  <= 0;
           starting <= 0;
        end
      else
        begin
           if (spiclockn)
             begin
                sclk     <= 0;
                starting <= 0;
                if (~enable)
                  begin
                     ready <= 1;
                     left  <= 0;
                  end
                else if (ready)
                  begin
                     latch <= data;
                     left  <= {count, 3'b0};
                     ready <= 0;
                  end
                else if (left > 0 && transmit_next)
                  begin
                     latch <= {latch[126:0], 1'b0};
                     left  <= left - 8'd1;
                  end
             end
           else if (spiclockp & transmitting)
             begin
                if (left[2:0] != 3'b000 | picready)
                  begin
                     sclk          <= 1;
                     transmit_next <= 1;
                     starting      <= left[2:0] == 3'b000;
                  end
                else transmit_next <= 0;
             end
        end

    assign done = ~ready & (left == 0);
    assign transmitting = ~ready & ~done;
    assign sdo = latch[127];

endmodule