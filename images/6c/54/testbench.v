`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg resetn;
    reg stall_in;
    reg valid_in;
    wire stall_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .resetn(resetn),
        .stall_in(stall_in),
        .valid_in(valid_in),
        .stall_out(stall_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        resetn = 0;
        valid_in = 0;
        stall_in = 0;
        @(posedge clock);
        #2;
        resetn = 1;
        @(posedge clock);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Reset State", test_num);
        resetn = 0;
        valid_in = 1;
        stall_in = 0;
        #5;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Transfer (valid_in=1, stall_in=0)", test_num);
        reset_dut();
        valid_in = 1;
        stall_in = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: No Input Data (valid_in=0, stall_in=0)", test_num);
        reset_dut();
        valid_in = 0;
        stall_in = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Downstream Stall (valid_in=1, stall_in=1)", test_num);
        reset_dut();
        valid_in = 1;
        stall_in = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Combined Condition (valid_in=0, stall_in=1)", test_num);
        reset_dut();
        valid_in = 0;
        stall_in = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Sequence of operations", test_num);
        reset_dut();


        valid_in = 1; stall_in = 0;
        @(posedge clock);
        #1;


        valid_in = 1; stall_in = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1, 0);
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
        input expected_stall_out;
        input expected_valid_out;
        begin
            if (expected_stall_out === (expected_stall_out ^ stall_out ^ expected_stall_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: stall_out=%b, valid_out=%b",
                         stall_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall_out=%b, valid_out=%b",
                         expected_stall_out, expected_valid_out);
                $display("  Got:      stall_out=%b, valid_out=%b",
                         stall_out, valid_out);
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
        $dumpvars(0,clock, resetn, stall_in, valid_in, stall_out, valid_out);
    end

endmodule
