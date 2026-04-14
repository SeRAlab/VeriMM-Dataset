`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg switch;
    wire request;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .switch(switch),
        .request(request)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clear = 1;
            switch = 0;
            @(posedge clock);
            #1 clear = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Detect valid sequence 1-0-1", test_num);
            reset_dut();
            @(posedge clock); switch = 1;
            @(posedge clock); switch = 0;
            @(posedge clock); switch = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid sequence 1-1-1", test_num);
            reset_dut();
            @(posedge clock); switch = 1;
            @(posedge clock); switch = 1;
            @(posedge clock); switch = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Partial sequence 1-0", test_num);
            reset_dut();
            @(posedge clock); switch = 1;
            @(posedge clock); switch = 0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid sequence 1-0-0", test_num);
            reset_dut();
            @(posedge clock); switch = 1;
            @(posedge clock); switch = 0;
            @(posedge clock); switch = 0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear asserted mid-sequence", test_num);
            reset_dut();
            @(posedge clock); switch = 1;
            @(posedge clock); switch = 0;
            clear = 1;
            @(posedge clock); switch = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Leading zeros before valid sequence", test_num);
            reset_dut();
            @(posedge clock); switch = 0;
            @(posedge clock); switch = 0;
            @(posedge clock); switch = 1;
            @(posedge clock); switch = 0;
            @(posedge clock); switch = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple detections", test_num);
            reset_dut();

            @(posedge clock); switch = 1;
            @(posedge clock); switch = 0;
            @(posedge clock); switch = 1;
            @(posedge clock); #1;

            @(posedge clock); switch = 1;
            @(posedge clock); switch = 0;
            @(posedge clock); switch = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
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
        input expected_request;
        begin
            if (expected_request === (expected_request ^ request ^ expected_request)) begin
                $display("PASS");
                $display("  Outputs: request=%b",
                         request);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: request=%b",
                         expected_request);
                $display("  Got:      request=%b",
                         request);
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
        $dumpvars(0,clear, clock, switch, request);
    end

endmodule
