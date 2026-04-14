`timescale 1ns/1ps

module clock_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg enable;
    reg [3:0] factor;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_divider dut (
        .clk_in(clk_in),
        .enable(enable),
        .factor(factor),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            factor = 4'd0;
            repeat(2) @(posedge clk_in);
            #1 reset = 0;
            @(posedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Factor=2, Enable=1. Checking toggle after 2 cycles.", test_num);
            reset_dut();
            factor = 4'd2;
            enable = 1;
            repeat(2) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Factor=2, Enable=1. Checking toggle back to 0 after 4 cycles.", test_num);
            reset_dut();
            factor = 4'd2;
            enable = 1;
            repeat(4) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Factor=4, Enable=1. Checking toggle after 4 cycles.", test_num);
            reset_dut();
            factor = 4'd4;
            enable = 1;
            repeat(4) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Factor=4, Enable=1. Checking toggle back to 0 after 8 cycles.", test_num);
            reset_dut();
            factor = 4'd4;
            enable = 1;
            repeat(8) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Factor=2, Enable=0. Output should remain low.", test_num);
            reset_dut();
            factor = 4'd2;
            enable = 0;
            repeat(10) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Factor=1, Enable=1. Checking toggle after 1 cycle.", test_num);
            reset_dut();
            factor = 4'd1;
            enable = 1;
            repeat(1) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Factor=3, Enable=1. Checking toggle after 3 cycles.", test_num);
            reset_dut();
            factor = 4'd3;
            enable = 1;
            repeat(3) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Factor=15, Enable=1. Checking toggle after 15 cycles.", test_num);
            reset_dut();
            factor = 4'd15;
            enable = 1;
            repeat(15) @(posedge clk_in);
            #1;
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
        $display("clock_divider Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, enable, factor, reset, clk_out);
    end

endmodule
