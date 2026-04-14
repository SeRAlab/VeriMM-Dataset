`timescale 1ns/1ps

module eth_rxstatem_tb;

    // Testbench signals (sequential circuit)
    reg ByteCntEq0;
    reg ByteCntGreat2;
    reg ByteCntMaxFrame;
    reg IFGCounterEq24;
    reg MRxClk;
    reg MRxDEq5;
    reg MRxDEqD;
    reg MRxDV;
    reg Reset;
    reg Transmitting;
    wire [1:0] StateData;
    wire StateDrop;
    wire StateIdle;
    wire StatePreamble;
    wire StateSFD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_rxstatem dut (
        .ByteCntEq0(ByteCntEq0),
        .ByteCntGreat2(ByteCntGreat2),
        .ByteCntMaxFrame(ByteCntMaxFrame),
        .IFGCounterEq24(IFGCounterEq24),
        .MRxClk(MRxClk),
        .MRxDEq5(MRxDEq5),
        .MRxDEqD(MRxDEqD),
        .MRxDV(MRxDV),
        .Reset(Reset),
        .Transmitting(Transmitting),
        .StateData(StateData),
        .StateDrop(StateDrop),
        .StateIdle(StateIdle),
        .StatePreamble(StatePreamble),
        .StateSFD(StateSFD)
    );

    // Clock generation (10ns period)
    initial begin
        MRxClk = 0;
        forever #5 MRxClk = ~MRxClk;
    end

        task reset_dut;

        begin
            Reset = 1;
            MRxDV = 0;
            Transmitting = 0;
            MRxDEq5 = 0;
            MRxDEqD = 0;
            ByteCntEq0 = 0;
            ByteCntGreat2 = 0;
            ByteCntMaxFrame = 0;
            IFGCounterEq24 = 0;
            #15;
            Reset = 0;
            @(posedge MRxClk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset to Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Idle to Preamble", test_num);
            reset_dut();

            MRxDV = 1;
            MRxDEq5 = 1;
            Transmitting = 0;
            @(posedge MRxClk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Preamble to SFD", test_num);
            reset_dut();

            MRxDV = 1; MRxDEq5 = 1; Transmitting = 0;
            @(posedge MRxClk);
            #1;

            MRxDEq5 = 0;
            MRxDEqD = 1;
            @(posedge MRxClk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: SFD to Data reception", test_num);
            reset_dut();

            MRxDV = 1; MRxDEq5 = 1; Transmitting = 0;
            @(posedge MRxClk);
            #1;

            MRxDEq5 = 0; MRxDEqD = 1;
            @(posedge MRxClk);
            #1;

            MRxDEqD = 0;
            ByteCntEq0 = 1;
            @(posedge MRxClk);
            #1;

            #1;


            check_outputs(2'b01, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Collision detection (Drop State)", test_num);
            reset_dut();

            MRxDV = 1;
            Transmitting = 1;
            @(posedge MRxClk);
            #1;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: End of frame (Data to Idle)", test_num);
            reset_dut();

            MRxDV = 1; MRxDEq5 = 1; @(posedge MRxClk); #1;
            MRxDEq5 = 0; MRxDEqD = 1; @(posedge MRxClk); #1;
            MRxDEqD = 0; @(posedge MRxClk); #1;

            MRxDV = 0;
            @(posedge MRxClk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Max Frame Length exceeded (Drop State)", test_num);
            reset_dut();

            MRxDV = 1; MRxDEq5 = 1; @(posedge MRxClk); #1;
            MRxDEq5 = 0; MRxDEqD = 1; @(posedge MRxClk); #1;
            MRxDEqD = 0; @(posedge MRxClk); #1;

            ByteCntMaxFrame = 1;
            @(posedge MRxClk);
            #1;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Drop recovery via IFG Counter", test_num);
            reset_dut();

            MRxDV = 1; Transmitting = 1; @(posedge MRxClk); #1;

            MRxDV = 0;
            Transmitting = 0;
            IFGCounterEq24 = 1;
            @(posedge MRxClk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eth_rxstatem Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [1:0] expected_StateData;
        input expected_StateDrop;
        input expected_StateIdle;
        input expected_StatePreamble;
        input expected_StateSFD;
        begin
            if (expected_StateData === (expected_StateData ^ StateData ^ expected_StateData) &&
                expected_StateDrop === (expected_StateDrop ^ StateDrop ^ expected_StateDrop) &&
                expected_StateIdle === (expected_StateIdle ^ StateIdle ^ expected_StateIdle) &&
                expected_StatePreamble === (expected_StatePreamble ^ StatePreamble ^ expected_StatePreamble) &&
                expected_StateSFD === (expected_StateSFD ^ StateSFD ^ expected_StateSFD)) begin
                $display("PASS");
                $display("  Outputs: StateData=%h, StateDrop=%b, StateIdle=%b, StatePreamble=%b, StateSFD=%b",
                         StateData, StateDrop, StateIdle, StatePreamble, StateSFD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: StateData=%h, StateDrop=%b, StateIdle=%b, StatePreamble=%b, StateSFD=%b",
                         expected_StateData, expected_StateDrop, expected_StateIdle, expected_StatePreamble, expected_StateSFD);
                $display("  Got:      StateData=%h, StateDrop=%b, StateIdle=%b, StatePreamble=%b, StateSFD=%b",
                         StateData, StateDrop, StateIdle, StatePreamble, StateSFD);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ByteCntEq0, ByteCntGreat2, ByteCntMaxFrame, IFGCounterEq24, MRxClk, MRxDEq5, MRxDEqD, MRxDV, Reset, Transmitting, StateData, StateDrop, StateIdle, StatePreamble, StateSFD);
    end

endmodule
