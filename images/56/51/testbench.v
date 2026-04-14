`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg j;
    wire p;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .j(j),
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
        j = 0;
        @(posedge clock);
        @(negedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        j = 1;
        @(posedge clock);
        #1;


        #1;



        check_outputs(0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        @(posedge clock);
        j = 1;
        @(negedge clock);
        #1;


        #1;



        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        j = 1;
        @(posedge clock);
        @(negedge clock);
        #1;

        #1;


        check_outputs(1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        j = 1;
        @(posedge clock);
        j = 0;
        #2;

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        j = 1;
        @(posedge clock);
        @(negedge clock);
        j = 0;
        @(posedge clock);
        @(negedge clock);
        #1;

        #1;


        check_outputs(0, 0);
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
        $dumpvars(0,clock, j, p, q);
    end

endmodule
