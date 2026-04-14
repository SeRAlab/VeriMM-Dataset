`timescale 1ns/1ps

module sequencer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hold_clk_busrq;
    reg hold_clk_iorq;
    reg hold_clk_wait;
    reg nextM;
    reg nreset;
    reg setM1;
    wire M1;
    wire M2;
    wire M3;
    wire M4;
    wire M5;
    wire T1;
    wire T2;
    wire T3;
    wire T4;
    wire T5;
    wire T6;
    wire timings_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sequencer dut (
        .clk(clk),
        .hold_clk_busrq(hold_clk_busrq),
        .hold_clk_iorq(hold_clk_iorq),
        .hold_clk_wait(hold_clk_wait),
        .nextM(nextM),
        .nreset(nreset),
        .setM1(setM1),
        .M1(M1),
        .M2(M2),
        .M3(M3),
        .M4(M4),
        .M5(M5),
        .T1(T1),
        .T2(T2),
        .T3(T3),
        .T4(T4),
        .T5(T5),
        .T6(T6),
        .timings_en(timings_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nreset = 0;
            hold_clk_busrq = 0;
            hold_clk_iorq = 0;
            hold_clk_wait = 0;
            nextM = 0;
            setM1 = 0;
            repeat(2) @(posedge clk);
            #1 nreset = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: T-cycle Progression (T1 -> T2 -> T3)", test_num);
            reset_dut();
            @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Transition M1 to M2 using nextM", test_num);
            reset_dut();
            nextM = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;


            #1;



            check_outputs(0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Hold Sequence via hold_clk_wait", test_num);
            reset_dut();
            @(posedge clk); #1;
            hold_clk_wait = 1;
            repeat(3) @(posedge clk); #1;

            #1;


            check_outputs(1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Hold Sequence via hold_clk_busrq", test_num);
            reset_dut();
            hold_clk_busrq = 1;
            repeat(2) @(posedge clk); #1;

            #1;


            check_outputs(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Explicitly set M1 via setM1", test_num);
            reset_dut();
            nextM = 1;
            @(posedge clk); #1;
            nextM = 0;
            setM1 = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Sequence through to M5", test_num);
            reset_dut();
            nextM = 1;
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %03d: Hold Sequence via hold_clk_iorq", test_num);
            reset_dut();
            hold_clk_iorq = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sequencer Testbench");
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
        input expected_M1;
        input expected_M2;
        input expected_M3;
        input expected_M4;
        input expected_M5;
        input expected_T1;
        input expected_T2;
        input expected_T3;
        input expected_T4;
        input expected_T5;
        input expected_T6;
        input expected_timings_en;
        begin
            if (expected_M1 === (expected_M1 ^ M1 ^ expected_M1) &&
                expected_M2 === (expected_M2 ^ M2 ^ expected_M2) &&
                expected_M3 === (expected_M3 ^ M3 ^ expected_M3) &&
                expected_M4 === (expected_M4 ^ M4 ^ expected_M4) &&
                expected_M5 === (expected_M5 ^ M5 ^ expected_M5) &&
                expected_T1 === (expected_T1 ^ T1 ^ expected_T1) &&
                expected_T2 === (expected_T2 ^ T2 ^ expected_T2) &&
                expected_T3 === (expected_T3 ^ T3 ^ expected_T3) &&
                expected_T4 === (expected_T4 ^ T4 ^ expected_T4) &&
                expected_T5 === (expected_T5 ^ T5 ^ expected_T5) &&
                expected_T6 === (expected_T6 ^ T6 ^ expected_T6) &&
                expected_timings_en === (expected_timings_en ^ timings_en ^ expected_timings_en)) begin
                $display("PASS");
                $display("  Outputs: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, T1=%b, T2=%b, T3=%b, T4=%b, T5=%b, T6=%b, timings_en=%b",
                         M1, M2, M3, M4, M5, T1, T2, T3, T4, T5, T6, timings_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, T1=%b, T2=%b, T3=%b, T4=%b, T5=%b, T6=%b, timings_en=%b",
                         expected_M1, expected_M2, expected_M3, expected_M4, expected_M5, expected_T1, expected_T2, expected_T3, expected_T4, expected_T5, expected_T6, expected_timings_en);
                $display("  Got:      M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, T1=%b, T2=%b, T3=%b, T4=%b, T5=%b, T6=%b, timings_en=%b",
                         M1, M2, M3, M4, M5, T1, T2, T3, T4, T5, T6, timings_en);
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
        $dumpvars(0,clk, hold_clk_busrq, hold_clk_iorq, hold_clk_wait, nextM, nreset, setM1, M1, M2, M3, M4, M5, T1, T2, T3, T4, T5, T6, timings_en);
    end

endmodule
