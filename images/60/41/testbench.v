`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg e;
    wire [3:0] comb_q;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .e(e),
        .comb_q(comb_q),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 0;
            b <= 0;
            e <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All inputs zero", test_num);
            reset_dut();
            a = 0; b = 0; e = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: a & b = 1, e = 0", test_num);
            reset_dut();
            a = 1; b = 1; e = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: a & b = 0, e = 1", test_num);
            reset_dut();
            a = 1; b = 0; e = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1111, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: a & b = 1, e = 1", test_num);
            reset_dut();
            a = 1; b = 1; e = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1111, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: a & b = 0 (0 & 1), e = 0", test_num);
            reset_dut();
            a = 0; b = 1; e = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0000);
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
        input [3:0] expected_comb_q;
        input [3:0] expected_q;
        begin
            if (expected_comb_q === (expected_comb_q ^ comb_q ^ expected_comb_q) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: comb_q=%h, q=%h",
                         comb_q, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comb_q=%h, q=%h",
                         expected_comb_q, expected_q);
                $display("  Got:      comb_q=%h, q=%h",
                         comb_q, q);
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
        $dumpvars(0,a, b, clk, e, comb_q, q);
    end

endmodule
