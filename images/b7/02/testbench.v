`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg y;
    wire p;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .y(y),
        .p(p),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        y = 1;
        force dut.p = 0;
        force dut.q = 0;
        #15;
        release dut.p;
        release dut.q;
        @(negedge clock);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case %0d: Toggle q on posedge", test_num);
        y = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case %0d: Toggle p on negedge", test_num);
        y = 0;
        @(negedge clock);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case %0d: Hold q on posedge (y=0)", test_num);
        y = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case %0d: Hold p on negedge (y=1)", test_num);
        y = 1;
        @(negedge clock);
        #2;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case %0d: Multiple toggles on q", test_num);
        y = 1;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test Case %0d: Multiple toggles on p", test_num);
        y = 0;
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test Case %0d: Toggle both p and q", test_num);

        y = 1;
        @(posedge clock);

        y = 0;
        @(negedge clock);
        #2;
        #1;

        check_outputs(1, 1);
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
        testcase007();
        
        
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
        input expected_p;
        input expected_q;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: p=%b, q=%b",
                         p, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%b, q=%b",
                         expected_p, expected_q);
                $display("  Got:      p=%b, q=%b",
                         p, q);
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
        $dumpvars(0,clock, y, p, q);
    end

endmodule
