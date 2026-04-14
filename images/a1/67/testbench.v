`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg io_clk;
    reg reset;
    wire io_led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_clk(io_clk),
        .reset(reset),
        .io_led(io_led)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: io_clk set to 0", test_num);

        reset = 1;
        clock = 0;
        io_clk = 0;
        #10;
        reset = 0;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: io_clk set to 1", test_num);

        reset = 1;
        clock = 0;
        io_clk = 1;
        #10;
        reset = 0;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Change io_clk from 0 to 1 after reset", test_num);

        reset = 1;
        clock = 0;
        io_clk = 0;
        #10;
        reset = 0;
        #5;
        io_clk = 1;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Change io_clk from 1 to 0 after reset", test_num);

        reset = 1;
        clock = 0;
        io_clk = 1;
        #10;
        reset = 0;
        #5;
        io_clk = 0;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pulse io_clk during reset", test_num);

        reset = 1;
        clock = 0;
        io_clk = 0;
        #5;
        io_clk = 1;
        #5;
        io_clk = 0;
        #5;
        reset = 0;
        #10;

        #1;


        check_outputs(1'b0);
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
        input expected_io_led;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_led === (expected_io_led ^ io_led ^ expected_io_led)) begin
                $display("PASS");
                $display("  Outputs: io_led=%b",
                         io_led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_led=%b",
                         expected_io_led);
                $display("  Got:      io_led=%b",
                         io_led);
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

endmodule
