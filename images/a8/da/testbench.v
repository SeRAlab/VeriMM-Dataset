`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire clk_1s;
    wire clk_1us;
    wire clk_500ms;
    wire clk_7seg;
    wire clk_LCD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_1s(clk_1s),
        .clk_1us(clk_1us),
        .clk_500ms(clk_500ms),
        .clk_7seg(clk_7seg),
        .clk_LCD(clk_LCD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin



            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check clk_1us after 500ns (50 cycles)", test_num);
            reset_dut();
            #500;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check clk_1us after 1000ns (100 cycles)", test_num);
            reset_dut();
            #1000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check clk_7seg after 0.5ms", test_num);
            reset_dut();
            #500000;



            #1;




            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify clk_1us at 1.5us", test_num);
            reset_dut();
            #1500;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_clk_1s;
        input expected_clk_1us;
        input expected_clk_500ms;
        input expected_clk_7seg;
        input expected_clk_LCD;
        begin
            if (expected_clk_1s === (expected_clk_1s ^ clk_1s ^ expected_clk_1s) &&
                expected_clk_1us === (expected_clk_1us ^ clk_1us ^ expected_clk_1us) &&
                expected_clk_500ms === (expected_clk_500ms ^ clk_500ms ^ expected_clk_500ms) &&
                expected_clk_7seg === (expected_clk_7seg ^ clk_7seg ^ expected_clk_7seg) &&
                expected_clk_LCD === (expected_clk_LCD ^ clk_LCD ^ expected_clk_LCD)) begin
                $display("PASS");
                $display("  Outputs: clk_1s=%b, clk_1us=%b, clk_500ms=%b, clk_7seg=%b, clk_LCD=%b",
                         clk_1s, clk_1us, clk_500ms, clk_7seg, clk_LCD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_1s=%b, clk_1us=%b, clk_500ms=%b, clk_7seg=%b, clk_LCD=%b",
                         expected_clk_1s, expected_clk_1us, expected_clk_500ms, expected_clk_7seg, expected_clk_LCD);
                $display("  Got:      clk_1s=%b, clk_1us=%b, clk_500ms=%b, clk_7seg=%b, clk_LCD=%b",
                         clk_1s, clk_1us, clk_500ms, clk_7seg, clk_LCD);
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
        $dumpvars(0,clk, clk_1s, clk_1us, clk_500ms, clk_7seg, clk_LCD);
    end

endmodule
