`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] compare_val;
    reg en;
    wire [3:0] Q;
    wire comp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .compare_val(compare_val),
        .en(en),
        .Q(Q),
        .comp_out(comp_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            compare_val = 0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to 1, compare_val=1", test_num);
            reset_dut();

            compare_val = 2'd1;
            en = 1'b1;
            @(posedge clk);
            en = 1'b0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to 3, compare_val=2", test_num);
            reset_dut();

            compare_val = 2'd2;
            en = 1'b1;
            repeat(3) @(posedge clk);
            en = 1'b0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to 1, compare_val=2 (False condition)", test_num);
            reset_dut();

            compare_val = 2'd2;
            en = 1'b1;
            @(posedge clk);
            en = 1'b0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to 15, compare_val=3", test_num);
            reset_dut();

            compare_val = 2'd3;
            en = 1'b1;
            repeat(15) @(posedge clk);
            en = 1'b0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap around from 15 to 0", test_num);
            reset_dut();

            compare_val = 2'd1;
            en = 1'b1;
            repeat(16) @(posedge clk);
            en = 1'b0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify counter holds value when en is low", test_num);
            reset_dut();

            compare_val = 2'd1;
            en = 1'b1;
            @(posedge clk);
            en = 1'b0;
            repeat(5) @(posedge clk);
            en = 1'b1;
            @(posedge clk);
            en = 1'b0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b1);
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
        input [3:0] expected_Q;
        input expected_comp_out;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_comp_out === (expected_comp_out ^ comp_out ^ expected_comp_out)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, comp_out=%b",
                         Q, comp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, comp_out=%b",
                         expected_Q, expected_comp_out);
                $display("  Got:      Q=%h, comp_out=%b",
                         Q, comp_out);
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
        $dumpvars(0,clk, compare_val, en, Q, comp_out);
    end

endmodule
