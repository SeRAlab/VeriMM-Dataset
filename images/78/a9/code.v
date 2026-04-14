module top_module(InputPulse, OneShot, Reset, CLOCK);input InputPulse, Reset, CLOCK;
    output reg OneShot;
    parameter State0=0, State1=1, State2=2, State3=3;
    reg [1:0] State;

    always @(posedge CLOCK) begin
        if (Reset == 1) begin
            State <= State0;
            OneShot <= 0;
        end else begin
            case (State)
                State0: if (InputPulse == 0) begin
                            State <= State0;
                            OneShot <= 0;
                        end else begin
                            State <= State1;
                            OneShot <= 1;
                        end
                State1: if (InputPulse == 0) begin
                            State <= State0;
                            OneShot <= 0;
                        end else begin
                            State <= State3;
                            OneShot <= 0;
                        end
                State2: begin
                            State <= State0;
                            OneShot <= 0;
                        end
                State3: if (InputPulse == 0) begin
                            State <= State0;
                            OneShot <= 0;
                        end else begin
                            State <= State3;
                            OneShot <= 1;
                        end
            endcase
        end
    end
endmodule