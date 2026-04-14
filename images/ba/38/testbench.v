`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [3:0] counter_q;
    wire [7:0] result_q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .counter_q(counter_q),
        .result_q(result_q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Cycle Operation", test_num);
            reset_dut();
            d = 8'h15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 8'h16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Cycles Constant Data", test_num);
            reset_dut();
            d = 8'h0A;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 8'h0D);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 4-bit Counter Wrap-around", test_num);
            reset_dut();
            d = 8'h00;

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'h0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 8-bit Addition Overflow", test_num);
            reset_dut();
            d = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Changing Data Sequence", test_num);
            reset_dut();
            d = 8'h10; @(posedge clk);
            d = 8'h20; @(posedge clk);
            d = 8'h30; @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 8'h33);
        end
        endtask

    task testcase007;

        integer j;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Counter and High Data", test_num);
            reset_dut();
            d = 8'hF0;

            for (j = 0; j < 15; j = j + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'hF, 8'hFF);
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
        input [3:0] expected_counter_q;
        input [7:0] expected_result_q;
        begin
            if (expected_counter_q === (expected_counter_q ^ counter_q ^ expected_counter_q) &&
                expected_result_q === (expected_result_q ^ result_q ^ expected_result_q)) begin
                $display("PASS");
                $display("  Outputs: counter_q=%h, result_q=%h",
                         counter_q, result_q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_q=%h, result_q=%h",
                         expected_counter_q, expected_result_q);
                $display("  Got:      counter_q=%h, result_q=%h",
                         counter_q, result_q);
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
        $dumpvars(0,clk, d, reset, counter_q, result_q);
    end

endmodule
