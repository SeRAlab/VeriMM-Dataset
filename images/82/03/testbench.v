`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg change;
    reg mode;
    reg turn;
    wire LD_hour;
    wire LD_min;
    wire count1;
    wire count2;
    wire counta;
    wire countb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .change(change),
        .mode(mode),
        .turn(turn),
        .LD_hour(LD_hour),
        .LD_min(LD_min),
        .count1(count1),
        .count2(count2),
        .counta(counta),
        .countb(countb)
    );

    // Clock generation (10ns period)
    initial begin
        mode = 0;
        forever #5 mode = ~mode;
    end

        task reset_dut;

    begin
        change = 0;
        turn = 0;

        repeat(3) @(posedge mode);
        @(negedge mode);
        change = 0;
        turn = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Verify Idle State (S0) with change=0", test_num);

        #1;


        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: State 1 - Adjust Minutes (turn flag=0, change=1)", test_num);
        @(posedge mode);
        @(negedge mode);
        change = 1;
        #2;

        #1;


        check_outputs(0, 1, 1, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: State 1 - Toggle flag to Adjust Hours (turn pulse, change=1)", test_num);
        @(posedge mode);
        @(negedge mode);
        turn = 1; #10; turn = 0;
        change = 1;
        #2;

        #1;


        check_outputs(1, 0, 0, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Verify State 2 behavior", test_num);
        @(posedge mode);
        @(posedge mode);
        @(negedge mode);
        change = 1;
        #2;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: State 1 - No change (change=0)", test_num);
        @(posedge mode);
        @(negedge mode);
        change = 0;
        #2;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Wrap around S2 -> S0", test_num);
        @(posedge mode);
        @(posedge mode);
        @(posedge mode);
        @(negedge mode);
        change = 1;
        #2;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
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
        testcase006();
        
        
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
        input expected_LD_hour;
        input expected_LD_min;
        input expected_count1;
        input expected_count2;
        input expected_counta;
        input expected_countb;
        begin
            if (expected_LD_hour === (expected_LD_hour ^ LD_hour ^ expected_LD_hour) &&
                expected_LD_min === (expected_LD_min ^ LD_min ^ expected_LD_min) &&
                expected_count1 === (expected_count1 ^ count1 ^ expected_count1) &&
                expected_count2 === (expected_count2 ^ count2 ^ expected_count2) &&
                expected_counta === (expected_counta ^ counta ^ expected_counta) &&
                expected_countb === (expected_countb ^ countb ^ expected_countb)) begin
                $display("PASS");
                $display("  Outputs: LD_hour=%b, LD_min=%b, count1=%b, count2=%b, counta=%b, countb=%b",
                         LD_hour, LD_min, count1, count2, counta, countb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LD_hour=%b, LD_min=%b, count1=%b, count2=%b, counta=%b, countb=%b",
                         expected_LD_hour, expected_LD_min, expected_count1, expected_count2, expected_counta, expected_countb);
                $display("  Got:      LD_hour=%b, LD_min=%b, count1=%b, count2=%b, counta=%b, countb=%b",
                         LD_hour, LD_min, count1, count2, counta, countb);
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
        $dumpvars(0,change, mode, turn, LD_hour, LD_min, count1, count2, counta, countb);
    end

endmodule
