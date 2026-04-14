`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clock;
    reg p;
    wire q;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clock(clock),
        .p(p),
        .q(q),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            a = 0;
            p = 0;

            repeat(4) @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: State 00, Inputs a=0, p=0", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(posedge clock);
            #2;
            $display("Testcase %0d: State 01, Inputs a=1, p=1", test_num);
            a = 1; p = 1; #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            @(posedge clock);
            @(posedge clock);
            #2;
            a = 1; p = 1; #1;
            $display("Testcase %0d: State 10, Inputs a=1, p=1", test_num);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #2;
            a = 1; p = 1; #1;
            $display("Testcase %0d: State 11, Inputs a=1, p=1", test_num);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            @(posedge clock);
            @(posedge clock);
            #2;
            a = 0; p = 1; #1;
            $display("Testcase %0d: State 10, Inputs a=0, p=1", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #2;
            a = 1; p = 0; #1;
            $display("Testcase %0d: State 11, Inputs a=1, p=0", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            repeat(4) @(posedge clock);
            #2;
            a = 1; p = 1; #1;
            $display("Testcase %0d: State 00 after full cycle, Inputs a=1, p=1", test_num);
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
        input expected_q;
        input expected_r;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: q=%b, r=%b",
                         q, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, r=%b",
                         expected_q, expected_r);
                $display("  Got:      q=%b, r=%b",
                         q, r);
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
        $dumpvars(0,a, clock, p, q, r);
    end

endmodule
