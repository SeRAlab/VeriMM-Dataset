`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fb_clk;
    reg ref_clk;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fb_clk(fb_clk),
        .ref_clk(ref_clk),
        .out_clk(out_clk)
    );

    // Clock generation (10ns period)
    initial begin
        fb_clk = 0;
        forever #5 fb_clk = ~fb_clk;
    end

        task reset_dut;

        begin
            ref_clk = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Basic Phase Locking", test_num);
            reset_dut();



            repeat(400) begin
                #5 ref_clk = ~ref_clk;
            end


            #2.5;
            #1;

            check_outputs(ref_clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Phase Alignment (Delayed Start)", test_num);
            reset_dut();

            #3;
            repeat(400) begin
                #5 ref_clk = ~ref_clk;
            end

            #2.5;
            #1;

            check_outputs(ref_clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Lock Acquisition After Delay", test_num);
            reset_dut();

            ref_clk = 0;
            #500;

            repeat(400) begin
                #5 ref_clk = ~ref_clk;
            end

            #2.5;
            #1;

            check_outputs(ref_clk);
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
        input expected_out_clk;
        begin
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b",
                         out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b",
                         expected_out_clk);
                $display("  Got:      out_clk=%b",
                         out_clk);
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
        $dumpvars(0,fb_clk, ref_clk, out_clk);
    end

endmodule
