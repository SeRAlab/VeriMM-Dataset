`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg rst_n;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst_n(rst_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Shift in 111111", test_num);
            reset_dut();
            repeat(6) begin
                in = 1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase003;

        reg [5:0] pattern;
        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Pattern 101101 Check", test_num);
            reset_dut();
            pattern = 6'b101101;
            for (i = 5; i >= 0; i = i - 1) begin
                in = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(6'b101101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overflow Check", test_num);
            reset_dut();

            in = 1;
            @(posedge clk);
            #1;

            repeat(6) begin
                in = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Partial Shift Check (3 cycles)", test_num);
            reset_dut();

            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            #1;

            check_outputs(6'b000101);
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
        input [5:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, in, rst_n, q);
    end

endmodule
