`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] in;
    wire [1:0] nedge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .nedge(nedge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative edge on bit 0 (01 -> 00)", test_num);
            reset_dut();
            @(posedge clk); #1; in = 2'b01;
            @(posedge clk); #1; in = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative edge on bit 1 (10 -> 00)", test_num);
            reset_dut();
            @(posedge clk); #1; in = 2'b10;
            @(posedge clk); #1; in = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative edges on both bits (11 -> 00)", test_num);
            reset_dut();
            @(posedge clk); #1; in = 2'b11;
            @(posedge clk); #1; in = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive edge (00 -> 11)", test_num);
            reset_dut();
            @(posedge clk); #1; in = 2'b00;
            @(posedge clk); #1; in = 2'b11;
            @(posedge clk); #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Stable High (11 -> 11)", test_num);
            reset_dut();
            @(posedge clk); #1; in = 2'b11;
            @(posedge clk); #1; in = 2'b11;
            @(posedge clk); #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle (11 -> 00 -> 11)", test_num);
            reset_dut();
            @(posedge clk); #1; in = 2'b11;
            @(posedge clk); #1; in = 2'b00;
            @(posedge clk); #1; in = 2'b11;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_nedge;
        begin
            if (expected_nedge === (expected_nedge ^ nedge ^ expected_nedge)) begin
                $display("PASS");
                $display("  Outputs: nedge=%h",
                         nedge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nedge=%h",
                         expected_nedge);
                $display("  Got:      nedge=%h",
                         nedge);
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
        $dumpvars(0,clk, in, nedge);
    end

endmodule
