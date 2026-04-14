`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire EQ;
    wire GT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .EQ(EQ),
        .GT(GT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A <= 0;
            B <= 0;


            repeat(15) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=42, B=42 (Equality)", test_num);
            reset_dut();
            A <= 8'd42;
            B <= 8'd42;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=100, B=50 (A > B)", test_num);
            reset_dut();
            A <= 8'd100;
            B <= 8'd50;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=25, B=75 (A < B)", test_num);
            reset_dut();
            A <= 8'd25;
            B <= 8'd75;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=255 (Max Equality)", test_num);
            reset_dut();
            A <= 8'hFF;
            B <= 8'hFF;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=0 (Min Equality)", test_num);
            reset_dut();
            A <= 8'h00;
            B <= 8'h00;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=0 (Max vs Min)", test_num);
            reset_dut();
            A <= 8'hFF;
            B <= 8'h00;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=129, B=128 (LSB difference)", test_num);
            reset_dut();
            A <= 8'd129;
            B <= 8'd128;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=127, B=128 (MSB difference)", test_num);
            reset_dut();
            A <= 8'd127;
            B <= 8'd128;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_EQ;
        input expected_GT;
        begin
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b",
                         EQ, GT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b",
                         expected_EQ, expected_GT);
                $display("  Got:      EQ=%b, GT=%b",
                         EQ, GT);
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
        $dumpvars(0,A, B, clk, EQ, GT);
    end

endmodule
