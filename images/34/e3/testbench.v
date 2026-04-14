`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg enable;
    wire clk_out_0;
    wire clk_out_180;
    wire clk_out_270;
    wire clk_out_90;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .enable(enable),
        .clk_out_0(clk_out_0),
        .clk_out_180(clk_out_180),
        .clk_out_270(clk_out_270),
        .clk_out_90(clk_out_90)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            enable = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Disabled State Check", test_num);
            reset_dut();
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enabled - Startup Phase Check (at +0.1ns)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk_in);
            #0.1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enabled - 90 Degree Phase Check (at +0.8ns)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk_in);
            #0.8;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enabled - 180 Degree Phase Check (at +1.4ns)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk_in);
            #1.4;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enabled - 270 Degree Phase Check (at +2.0ns)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk_in);
            #2.0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Deactivation Mid-Cycle Check", test_num);
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk_in);
            enable = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll_4x Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_clk_out_0;
        input expected_clk_out_180;
        input expected_clk_out_270;
        input expected_clk_out_90;
        begin
            if (expected_clk_out_0 === (expected_clk_out_0 ^ clk_out_0 ^ expected_clk_out_0) &&
                expected_clk_out_180 === (expected_clk_out_180 ^ clk_out_180 ^ expected_clk_out_180) &&
                expected_clk_out_270 === (expected_clk_out_270 ^ clk_out_270 ^ expected_clk_out_270) &&
                expected_clk_out_90 === (expected_clk_out_90 ^ clk_out_90 ^ expected_clk_out_90)) begin
                $display("PASS");
                $display("  Outputs: clk_out_0=%b, clk_out_180=%b, clk_out_270=%b, clk_out_90=%b",
                         clk_out_0, clk_out_180, clk_out_270, clk_out_90);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out_0=%b, clk_out_180=%b, clk_out_270=%b, clk_out_90=%b",
                         expected_clk_out_0, expected_clk_out_180, expected_clk_out_270, expected_clk_out_90);
                $display("  Got:      clk_out_0=%b, clk_out_180=%b, clk_out_270=%b, clk_out_90=%b",
                         clk_out_0, clk_out_180, clk_out_270, clk_out_90);
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
        $dumpvars(0,clk_in, enable, clk_out_0, clk_out_180, clk_out_270, clk_out_90);
    end

endmodule
