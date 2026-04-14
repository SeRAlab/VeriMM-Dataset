`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    wire [63:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_test;

        input signed [31:0] in_a;
        input signed [31:0] in_b;
        begin
            test_num = test_num + 1;
            A = in_a;
            B = in_b;

            repeat(64) @(posedge clk);
            $display("Test %0d: %d * %d", test_num, in_a, in_b);
            #1;

            check_outputs(64'(in_a) * 64'(in_b));
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_test(32'd10, 32'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_test(32'd15, -32'd4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_test(-32'd12, 32'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_test(-32'd7, -32'd8);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_test(32'd0, 32'd123456);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_test(32'd1, -32'd98765);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_test(32'h7FFFFFFF, 32'd2);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            run_test(32'h80000000, 32'd1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            run_test(32'sd100000, -32'sd200000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            run_test(32'hAAAAAAAA, 32'h55555555);
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
        testcase010();
        
        
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
        input [63:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, B, clk, Y);
    end

endmodule
