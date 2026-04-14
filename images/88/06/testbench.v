`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] c;
    reg clk;
    reg [7:0] r;
    wire [7:0] e;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .clk(clk),
        .r(r),
        .e(e)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            r = 0;
            c = 0;

            repeat(6) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            c = 4'b0001;
            r = 8'd123;
            @(posedge clk);
            r = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd123);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            c = 4'b1000;
            r = 8'd55;
            @(posedge clk);
            r = 8'd0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            c = 4'b0011;
            r = 8'd10;
            @(posedge clk);
            r = 8'd20;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            c = 4'b0011;
            r = 8'd150;
            @(posedge clk);
            r = 8'd200;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd94);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            c = 4'b1111;
            r = 8'd5;
            repeat(4) @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd20);
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
        input [7:0] expected_e;
        begin
            if (expected_e === (expected_e ^ e ^ expected_e)) begin
                $display("PASS");
                $display("  Outputs: e=%h",
                         e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%h",
                         expected_e);
                $display("  Got:      e=%h",
                         e);
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
        $dumpvars(0,c, clk, r, e);
    end

endmodule
