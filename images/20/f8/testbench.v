`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [7:0] frac_div;
    reg reset;
    wire clk_out;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .frac_div(frac_div),
        .reset(reset),
        .clk_out(clk_out),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            reset = 1;
            frac_div = 8'd0;
            @(posedge clk_ref);
            #1 reset = 0;
            @(posedge clk_ref);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();

            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Locking with Small Divisor (frac_div=10)", test_num);
            reset_dut();
            frac_div = 8'd10;


            repeat(50) @(posedge clk_ref);
            #2;


            #1;



            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Locking with Large Divisor (frac_div=255)", test_num);
            reset_dut();
            frac_div = 8'd255;
            repeat(100) @(posedge clk_ref);
            #2;
            #1;

            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Divisor Change", test_num);
            reset_dut();
            frac_div = 8'd20;
            repeat(50) @(posedge clk_ref);

            frac_div = 8'd40;


            repeat(50) @(posedge clk_ref);
            #2;
            #1;

            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verification of Stable Output when Unlocked", test_num);
            reset_dut();

            frac_div = 8'd0;
            repeat(10) @(posedge clk_ref);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        $dumpvars(0,clk_ref, frac_div, reset, clk_out, locked);
    end

endmodule
