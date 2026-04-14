`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fb_clk;
    reg ref_clk;
    reg reset;
    wire locked;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fb_clk(fb_clk),
        .ref_clk(ref_clk),
        .reset(reset),
        .locked(locked),
        .out_clk(out_clk)
    );

    // Clock generation (10ns period)
    initial begin
        ref_clk = 0;
        forever #5 ref_clk = ~ref_clk;
    end

        task reset_dut;

        begin
            reset = 1;
            fb_gen_en = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Lock Alignment", test_num);
            reset_dut();
            fb_gen_en = 1;
            fb_delay = 0;


            #5000;



            #1;




            check_outputs(1'b1, out_clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No Feedback Clock Lock Failure", test_num);
            reset_dut();
            fb_gen_en = 0;

            #2000;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Impact During Lock", test_num);
            reset_dut();
            fb_gen_en = 1;
            fb_delay = 0;
            #2000;

            reset = 1;
            #50;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DLL Fine-tune Phase Offset", test_num);
            reset_dut();
            fb_gen_en = 1;
            fb_delay = 2.5;

            #8000;


            #1;



            check_outputs(1'b1, out_clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rapid Reset Recovery", test_num);
            reset_dut();
            #100;
            reset = 1; #5; reset = 0; #5; reset = 1; #5; reset = 0;

            fb_gen_en = 1;
            fb_delay = 0;
            #5000;

            #1;


            check_outputs(1'b1, out_clk);
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
        input expected_locked;
        input expected_out_clk;
        begin
            if (expected_locked === (expected_locked ^ locked ^ expected_locked) &&
                expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: locked=%b, out_clk=%b",
                         locked, out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: locked=%b, out_clk=%b",
                         expected_locked, expected_out_clk);
                $display("  Got:      locked=%b, out_clk=%b",
                         locked, out_clk);
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
        $dumpvars(0,fb_clk, ref_clk, reset, locked, out_clk);
    end

endmodule
