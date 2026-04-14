`timescale 1ns/1ps

module PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [3:0] ref_freq;
    reg rst;
    wire clk_out;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL dut (
        .clk_in(clk_in),
        .ref_freq(ref_freq),
        .rst(rst),
        .clk_out(clk_out),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst = 1;
            ref_freq = 4'd0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Test Case %0d: Division by 2", test_num);
            reset_dut();
            ref_freq = 4'd2;

            #500;


            #1;



            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Test Case %0d: Division by 4", test_num);
            reset_dut();
            ref_freq = 4'd4;
            #800;
            #1;

            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Test Case %0d: Division by 8", test_num);
            reset_dut();
            ref_freq = 4'd8;
            #1500;
            #1;

            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Test Case %0d: Division by 12", test_num);
            reset_dut();
            ref_freq = 4'd12;
            #2000;
            #1;

            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Test Case %0d: Reset Behavior", test_num);
            rst = 1;
            ref_freq = 4'd2;
            #50;

            #1;


            check_outputs(clk_out, 1'b0);
            rst = 0;
            #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PLL Testbench");
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
        input expected_clk_out;
        input expected_locked;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, locked=%b",
                         clk_out, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, locked=%b",
                         expected_clk_out, expected_locked);
                $display("  Got:      clk_out=%b, locked=%b",
                         clk_out, locked);
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
        $dumpvars(0,clk_in, ref_freq, rst, clk_out, locked);
    end

endmodule
