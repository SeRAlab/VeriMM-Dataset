`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_bit;
    reg reset;
    wire [3:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .new_bit(new_bit),
        .reset(reset),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            new_bit = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Verify Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift in 4 ones (1111)", test_num);
            reset_dut();
            @(negedge clk);
            new_bit = 1;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift in pattern 1011", test_num);
            reset_dut();
            @(negedge clk);
            new_bit = 1;
            @(negedge clk);
            new_bit = 0;
            @(negedge clk);
            new_bit = 1;
            @(negedge clk);
            new_bit = 1;
            @(negedge clk);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift 6 bits (Overflow check)", test_num);
            reset_dut();
            @(negedge clk);


            new_bit = 1; @(negedge clk);
            new_bit = 0; @(negedge clk);
            new_bit = 1; @(negedge clk);
            new_bit = 1; @(negedge clk);
            new_bit = 0; @(negedge clk);
            new_bit = 1; @(negedge clk);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift in only 2 bits", test_num);
            reset_dut();
            @(negedge clk);
            new_bit = 1; @(negedge clk);
            new_bit = 1; @(negedge clk);

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Shift in zeros after ones", test_num);
            reset_dut();
            @(negedge clk);
            new_bit = 1;
            repeat(4) @(negedge clk);
            new_bit = 0;
            repeat(2) @(negedge clk);

            #1;


            check_outputs(4'b1100);
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
        input [3:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,clk, new_bit, reset, shift_reg);
    end

endmodule
