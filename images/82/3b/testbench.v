`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg reset_n;
    wire [7:0] LEDs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .reset_n(reset_n),
        .LEDs(LEDs)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            $display("\nResetting system...");
            reset_n = 0;
            @(posedge clk_i);
            #2;
            reset_n = 1;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking State after 1 cycle", test_num);
            reset_dut();
            repeat(1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking State after 3 cycles", test_num);
            reset_dut();
            repeat(3) @(posedge clk_i);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking State after 7 cycles (Bit 7)", test_num);
            reset_dut();
            repeat(7) @(posedge clk_i);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking Wrap-around (8 cycles)", test_num);
            reset_dut();
            repeat(8) @(posedge clk_i);
            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking 17 cycles (Double wrap + 1)", test_num);
            reset_dut();
            repeat(17) @(posedge clk_i);
            #1;
            #1;

            check_outputs(8'h02);
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
        input [7:0] expected_LEDs;
        begin
            if (expected_LEDs === (expected_LEDs ^ LEDs ^ expected_LEDs)) begin
                $display("PASS");
                $display("  Outputs: LEDs=%h",
                         LEDs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDs=%h",
                         expected_LEDs);
                $display("  Got:      LEDs=%h",
                         LEDs);
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
        $dumpvars(0,clk_i, reset_n, LEDs);
    end

endmodule
