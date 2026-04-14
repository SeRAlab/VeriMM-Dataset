`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    wire [3:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing first upper nibble increment (16 cycles total)", test_num);

            reset_dut();
            repeat (15) @(negedge CLK);
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing second upper nibble increment (32 cycles total)", test_num);
            reset_dut();
            repeat (15) @(negedge CLK);
            #1;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing halfway point (128 cycles total)", test_num);
            reset_dut();
            repeat (95) @(negedge CLK);
            #1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing counter rollover (256 cycles total)", test_num);
            reset_dut();
            repeat (127) @(negedge CLK);
            #1;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_led;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
        $dumpvars(0,CLK, led);
    end

endmodule
