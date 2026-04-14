`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [23:0] clock_divider;
    wire output_clock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .clock_divider(clock_divider),
        .output_clock(output_clock)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clock_divider = 24'd0;
            repeat(2) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=2, checking cycle 2 (expect pulse high)", test_num);
            reset_dut();
            clock_divider = 24'd2;
            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=2, checking cycle 1 (expect pulse low)", test_num);
            reset_dut();
            clock_divider = 24'd2;
            repeat(1) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=4, checking cycle 4 (expect pulse high)", test_num);
            reset_dut();
            clock_divider = 24'd4;
            repeat(4) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=4, checking cycle 3 (expect pulse low)", test_num);
            reset_dut();
            clock_divider = 24'd4;
            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=10, checking cycle 10 (expect pulse high)", test_num);
            reset_dut();
            clock_divider = 24'd10;
            repeat(10) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=10, checking cycle 11 (expect pulse low)", test_num);
            reset_dut();
            clock_divider = 24'd10;
            repeat(11) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=100, checking cycle 100", test_num);
            reset_dut();
            clock_divider = 24'd100;
            repeat(100) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: clock_divider=1, checking cycle 1", test_num);
            reset_dut();
            clock_divider = 24'd1;
            repeat(1) @(posedge clock);
            #1;
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
        input expected_output_clock;
        begin
            if (expected_output_clock === (expected_output_clock ^ output_clock ^ expected_output_clock)) begin
                $display("PASS");
                $display("  Outputs: output_clock=%b",
                         output_clock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_clock=%b",
                         expected_output_clock);
                $display("  Got:      output_clock=%b",
                         output_clock);
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
        $dumpvars(0,clock, clock_divider, output_clock);
    end

endmodule
