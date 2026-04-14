`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] Amax;
    reg CE;
    reg clk;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Amax(Amax),
        .CE(CE),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            Amax = 0;
            CE = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 32'd100;
            Amax = 32'd50;
            CE = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Simple Addition (100 + 50)", test_num);
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 32'd100;
            Amax = 32'd40;
            CE = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Simple Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 32'd10;
            Amax = 32'd20;
            CE = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Negative Result Subtraction (10 - 20)", test_num);
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 32'hFFFFFFFF;
            Amax = 32'd1;
            CE = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Addition Overflow (Max + 1)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 32'h7FFFFFFF;
            Amax = 32'h7FFFFFFF;
            CE = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Large Value Addition", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 32'd555;
            Amax = 32'd555;
            CE = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Zero Result", test_num);
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,A, Amax, CE, clk, out);
    end

endmodule
