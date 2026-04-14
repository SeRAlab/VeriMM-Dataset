`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] ByteCnt;
    reg MTxClk;
    reg [15:0] NibCnt;
    reg Reset;
    reg [3:0] RetryCnt;
    reg StateJam;
    reg StateJam_q;
    wire RandomEq0;
    wire RandomEqByteCnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ByteCnt(ByteCnt),
        .MTxClk(MTxClk),
        .NibCnt(NibCnt),
        .Reset(Reset),
        .RetryCnt(RetryCnt),
        .StateJam(StateJam),
        .StateJam_q(StateJam_q),
        .RandomEq0(RandomEq0),
        .RandomEqByteCnt(RandomEqByteCnt)
    );

    // Clock generation (10ns period)
    initial begin
        MTxClk = 0;
        forever #5 MTxClk = ~MTxClk;
    end

        task reset_dut;

        begin
            Reset = 1;
            StateJam = 0;
            StateJam_q = 0;
            RetryCnt = 4'h0;
            NibCnt = 16'h0;
            ByteCnt = 10'h0;
            repeat (2) @(posedge MTxClk);
            #1 Reset = 0;
            repeat (1) @(posedge MTxClk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Latch after Reset", test_num);
            reset_dut();


            ByteCnt = 10'h000;
            NibCnt = 16'h0000;
            RetryCnt = 4'h1;


            StateJam = 1;
            StateJam_q = 0;

            @(posedge MTxClk);
            #2;



            #1;




            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: LFSR Run and Latch", test_num);
            reset_dut();


            repeat (10) @(posedge MTxClk);


            RetryCnt = 4'hA;
            ByteCnt = 10'h123;


            StateJam = 1;
            StateJam_q = 0;

            @(posedge MTxClk);
            #2;



            #1;




            check_outputs(RandomEq0, RandomEqByteCnt);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Edge-triggered Latch Verification", test_num);
            reset_dut();


            StateJam = 1;
            StateJam_q = 0;
            RetryCnt = 4'h5;
            @(posedge MTxClk);
            #1;
            StateJam_q = 1;


            repeat (5) @(posedge MTxClk);


            #1;



            check_outputs(RandomEq0, RandomEqByteCnt);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: RetryCnt Masking", test_num);
            reset_dut();

            repeat (20) @(posedge MTxClk);

            RetryCnt = 4'h0;
            StateJam = 1;
            StateJam_q = 0;

            @(posedge MTxClk);
            #2;


            #1;



            check_outputs(RandomEq0, RandomEqByteCnt);
        end
        endtask

    task testcase005;

        reg [9:0] observed_random;
        begin
            test_num = 5;
            $display("Testcase %0d: Comparison with ByteCnt", test_num);
            reset_dut();

            repeat (5) @(posedge MTxClk);


            RetryCnt = 4'hA;
            StateJam = 1;
            StateJam_q = 0;
            @(posedge MTxClk);
            #2;



            ByteCnt = 10'h3FF;
            NibCnt = 16'hFFFF;
            #1;

            #1;


            check_outputs(RandomEq0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_RandomEq0;
        input expected_RandomEqByteCnt;
        begin
            if (expected_RandomEq0 === (expected_RandomEq0 ^ RandomEq0 ^ expected_RandomEq0) &&
                expected_RandomEqByteCnt === (expected_RandomEqByteCnt ^ RandomEqByteCnt ^ expected_RandomEqByteCnt)) begin
                $display("PASS");
                $display("  Outputs: RandomEq0=%b, RandomEqByteCnt=%b",
                         RandomEq0, RandomEqByteCnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RandomEq0=%b, RandomEqByteCnt=%b",
                         expected_RandomEq0, expected_RandomEqByteCnt);
                $display("  Got:      RandomEq0=%b, RandomEqByteCnt=%b",
                         RandomEq0, RandomEqByteCnt);
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
        $dumpvars(0,ByteCnt, MTxClk, NibCnt, Reset, RetryCnt, StateJam, StateJam_q, RandomEq0, RandomEqByteCnt);
    end

endmodule
