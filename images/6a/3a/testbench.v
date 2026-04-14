`timescale 1ns/1ps

module one_more_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clock;
    wire b;
    wire c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    one_more_module dut (
        .a(a),
        .clock(clock),
        .b(b),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        a = 0;


        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        #1;
    end
    endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift 1, 1", test_num);
        reset_dut();
        a = 1;
        @(posedge clock);
        #1;
        a = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift 1, 0", test_num);
        reset_dut();
        a = 1;
        @(posedge clock);
        #1;
        a = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift 0, 1", test_num);
        reset_dut();
        a = 0;
        @(posedge clock);
        #1;
        a = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift 0, 0", test_num);
        reset_dut();
        a = 0;
        @(posedge clock);
        #1;
        a = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequence 1-1-0-1", test_num);
        reset_dut();
        a = 1; @(posedge clock); #1;
        a = 1; @(posedge clock); #1;
        a = 0; @(posedge clock); #1;
        a = 1; @(posedge clock); #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Steady State High", test_num);
        reset_dut();
        a = 1;
        @(posedge clock); #1;
        @(posedge clock); #1;
        @(posedge clock); #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("one_more_module Testbench");
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
        input expected_b;
        input expected_c;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: b=%b, c=%b",
                         b, c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%b, c=%b",
                         expected_b, expected_c);
                $display("  Got:      b=%b, c=%b",
                         b, c);
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
        $dumpvars(0,a, clock, b, c);
    end

endmodule
