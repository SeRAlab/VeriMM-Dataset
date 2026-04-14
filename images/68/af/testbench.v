`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] d1;
    reg [31:0] d2;
    reg [4:0] d3;
    reg r;
    wire [1:0] q1;
    wire [31:0] q2;
    wire [4:0] q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .r(r),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            r = 1;
            d1 = 2'b0;
            d2 = 32'b0;
            d3 = 5'b0;
            @(negedge clk);
            r = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(2'h0, 32'h0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load Standard Values", test_num);
            reset_dut();
            @(negedge clk);
            d1 = 2'h2;
            d2 = 32'hDEADBEEF;
            d3 = 5'h15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'h2, 32'hDEADBEEF, 5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Load Maximum Bit Values", test_num);
            reset_dut();
            @(negedge clk);
            d1 = 2'h3;
            d2 = 32'hFFFFFFFF;
            d3 = 5'h1F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'h3, 32'hFFFFFFFF, 5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reset Priority Over Data", test_num);
            reset_dut();
            @(negedge clk);
            d1 = 2'h1;
            d2 = 32'hAAAA5555;
            d3 = 5'h0A;
            r = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'h0, 32'h0, 5'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Sequential Cycle Updates", test_num);
            reset_dut();
            @(negedge clk);
            d1 = 2'h1; d2 = 32'h1; d3 = 5'h1;
            @(posedge clk);
            @(negedge clk);
            d1 = 2'h2; d2 = 32'h2; d3 = 5'h2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'h2, 32'h2, 5'h2);
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
        input [1:0] expected_q1;
        input [31:0] expected_q2;
        input [4:0] expected_q3;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_q3 === (expected_q3 ^ q3 ^ expected_q3)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h, q3=%h",
                         q1, q2, q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h, q3=%h",
                         expected_q1, expected_q2, expected_q3);
                $display("  Got:      q1=%h, q2=%h, q3=%h",
                         q1, q2, q3);
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
        $dumpvars(0,clk, d1, d2, d3, r, q1, q2, q3);
    end

endmodule
