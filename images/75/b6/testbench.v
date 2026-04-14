`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] delay;
    reg input_clk;
    wire output_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .delay(delay),
        .input_clk(input_clk),
        .output_clk(output_clk)
    );

    // Clock generation (10ns period)
    initial begin
        input_clk = 0;
        forever #5 input_clk = ~input_clk;
    end

        task reset_dut;

        begin
            delay = 32'hFFFFFFFF;
            repeat (5) @(posedge input_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Zero Delay", test_num);
            reset_dut();
            delay = 32'd0;

            repeat (2) @(posedge input_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Small Delay (Active phase check)", test_num);
            reset_dut();
            delay = 32'd5;

            repeat (10) @(posedge input_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Small Delay (Gated phase check)", test_num);
            reset_dut();
            delay = 32'd10;

            repeat (4) @(posedge input_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Large Delay", test_num);
            reset_dut();
            delay = 32'd100;

            repeat (110) @(posedge input_clk);
            #2;
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
        input expected_output_clk;
        begin
            if (expected_output_clk === (expected_output_clk ^ output_clk ^ expected_output_clk)) begin
                $display("PASS");
                $display("  Outputs: output_clk=%b",
                         output_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_clk=%b",
                         expected_output_clk);
                $display("  Got:      output_clk=%b",
                         output_clk);
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
        $dumpvars(0,delay, input_clk, output_clk);
    end

endmodule
