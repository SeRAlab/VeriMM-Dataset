module top_module(
    input InputPulse,
    input Reset,
    input CLOCK,
    output reg OneShot
);parameter State0 = 0;
    parameter State1 = 1;
    parameter State2 = 2;
    parameter State3 = 3;
    
    reg [1:0] State;
    
    always @ (posedge CLOCK) begin
        if (Reset == 1) begin
            State <= State0;
            OneShot <= 0;
        end else begin
            case (State)
                State0: begin
                    if (InputPulse == 1) begin
                        State <= State1;
                        OneShot <= 0;
                    end else begin
                        State <= State0;
                        OneShot <= 0;
                    end
                end
                State1: begin
                    if (InputPulse == 0) begin
                        State <= State2;
                        OneShot <= 1;
                    end else begin
                        State <= State1;
                        OneShot <= 0;
                    end
                end
                State2: begin
                    State <= State0;
                    OneShot <= 0;
                end
                State3: begin
                    if (InputPulse == 0) begin
                        State <= State0;
                        OneShot <= 0;
                    end else begin
                        State <= State3;
                        OneShot <= 0;
                    end
                end
            endcase
        end
    end
    
endmodule