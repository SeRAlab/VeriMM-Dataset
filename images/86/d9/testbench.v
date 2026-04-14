`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_l;
    reg [3:0] data;
    reg enable_l;
    reg load;
    reg reset;
    wire carry_out;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_l(clk_l),
        .data(data),
        .enable_l(enable_l),
        .load(load),
        .reset(reset),
        .carry_out(carry_out),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk_l = 0;
        forever #5 clk_l = ~clk_l;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            enable_l = 1;
            data = 4'b0000;
            @(posedge clk_l);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data 4'hA", test_num);
            reset_dut();
            data = 4'hA;
            load = 1;
            @(posedge clk_l);
            #1;
            load = 0;
            #1;

            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Increment (3 steps)", test_num);
            reset_dut();
            enable_l = 0;
            repeat(3) @(posedge clk_l);
            #1;
            enable_l = 1;
            #1;

            check_outputs(1'b0, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Out at Max Count (4'hF)", test_num);
            reset_dut();
            data = 4'hF;
            load = 1;
            @(posedge clk_l);
            #1;
            load = 0;

            #1;


            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap around from 15 to 0", test_num);
            reset_dut();
            data = 4'hF;
            load = 1;
            @(posedge clk_l);
            #1;
            load = 0;
            enable_l = 0;
            @(posedge clk_l);
            #1;
            enable_l = 1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disable counting (enable_l=1)", test_num);
            reset_dut();
            data = 4'h5;
            load = 1;
            @(posedge clk_l);
            #1;
            load = 0;
            enable_l = 1;
            repeat(5) @(posedge clk_l);
            #1;

            #1;


            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority - Reset vs Load", test_num);
            reset_dut();
            data = 4'hC;
            load = 1;
            reset = 1;
            @(posedge clk_l);
            #1;
            reset = 0;
            load = 0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority - Load vs Enable", test_num);
            reset_dut();
            data = 4'h7;
            load = 1;
            enable_l = 0;
            @(posedge clk_l);
            #1;
            load = 0;
            enable_l = 1;
            #1;

            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment from 0 to 14", test_num);
            reset_dut();
            enable_l = 0;
            repeat(14) @(posedge clk_l);
            #1;
            enable_l = 1;
            #1;

            check_outputs(1'b0, 4'hE);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_carry_out;
        input [3:0] expected_count;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, count=%h",
                         carry_out, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, count=%h",
                         expected_carry_out, expected_count);
                $display("  Got:      carry_out=%b, count=%h",
                         carry_out, count);
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
        $dumpvars(0,clk_l, data, enable_l, load, reset, carry_out, count);
    end

endmodule
