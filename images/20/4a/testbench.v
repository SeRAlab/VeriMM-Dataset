`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out_0;
    wire clk_out_1;
    wire clk_out_2;
    wire clk_out_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out_0(clk_out_0),
        .clk_out_1(clk_out_1),
        .clk_out_2(clk_out_2),
        .clk_out_3(clk_out_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            #20;
            reset = 0;

            repeat(10) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase 001: Reference alignment (0 degrees)");
            reset_dut();
            @(posedge clk_in);
            #0.1;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: Quadrature alignment (90 degrees)");
            reset_dut();
            @(posedge clk_in);
            #0.725;

            #1;


            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: Half-cycle alignment (180 degrees)");
            reset_dut();
            @(posedge clk_in);
            #1.35;

            #1;


            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Three-quarter alignment (270 degrees)");
            reset_dut();
            @(posedge clk_in);
            #1.975;

            #1;


            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase 005: 4x Frequency check (Second output cycle)");
            reset_dut();
            @(posedge clk_in);
            #2.6;

            #1;


            check_outputs(1, 0, 0, 0);
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
        input expected_clk_out_1;
        input expected_clk_out_2;
        input expected_clk_out_3;
        begin
            if (expected_clk_out_0 === (expected_clk_out_0 ^ clk_out_0 ^ expected_clk_out_0) &&
                expected_clk_out_1 === (expected_clk_out_1 ^ clk_out_1 ^ expected_clk_out_1) &&
                expected_clk_out_2 === (expected_clk_out_2 ^ clk_out_2 ^ expected_clk_out_2) &&
                expected_clk_out_3 === (expected_clk_out_3 ^ clk_out_3 ^ expected_clk_out_3)) begin
                $display("PASS");
                $display("  Outputs: clk_out_0=%b, clk_out_1=%b, clk_out_2=%b, clk_out_3=%b",
                         clk_out_0, clk_out_1, clk_out_2, clk_out_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out_0=%b, clk_out_1=%b, clk_out_2=%b, clk_out_3=%b",
                         expected_clk_out_0, expected_clk_out_1, expected_clk_out_2, expected_clk_out_3);
                $display("  Got:      clk_out_0=%b, clk_out_1=%b, clk_out_2=%b, clk_out_3=%b",
                         clk_out_0, clk_out_1, clk_out_2, clk_out_3);
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
        $dumpvars(0,clk_in, reset, clk_out_0, clk_out_1, clk_out_2, clk_out_3);
    end

endmodule
