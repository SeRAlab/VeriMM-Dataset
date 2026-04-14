`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    wire [15:0] acc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .acc(acc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 16'h0000;
            force dut.acc = 16'h0000;
            @(posedge clk);
            #1;
            release dut.acc;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition", test_num);
            reset_dut();
            data = 16'h000A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Accumulations", test_num);
            reset_dut();
            data = 16'd100; @(posedge clk); #1;
            data = 16'd250; @(posedge clk); #1;
            data = 16'd150; @(posedge clk); #1;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Wrap-around", test_num);
            reset_dut();
            data = 16'hFFFF; @(posedge clk); #1;
            data = 16'h0001; @(posedge clk); #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition", test_num);
            reset_dut();
            data = 16'hABCD; @(posedge clk); #1;
            data = 16'h0000; @(posedge clk); #1;
            data = 16'h0000; @(posedge clk); #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Value Stress", test_num);
            reset_dut();
            data = 16'h8000; @(posedge clk); #1;
            data = 16'h8000; @(posedge clk); #1;
            data = 16'hFFFF; @(posedge clk); #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Increments", test_num);
            reset_dut();
            data = 16'h0001;
            repeat(10) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'h000A);
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
        input [15:0] expected_acc;
        begin
            if (expected_acc === (expected_acc ^ acc ^ expected_acc)) begin
                $display("PASS");
                $display("  Outputs: acc=%h",
                         acc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acc=%h",
                         expected_acc);
                $display("  Got:      acc=%h",
                         acc);
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
        $dumpvars(0,clk, data, acc);
    end

endmodule
