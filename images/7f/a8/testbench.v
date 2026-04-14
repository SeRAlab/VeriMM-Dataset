`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire A_greater_than_B;
    wire A_less_than_B;
    wire equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .A_greater_than_B(A_greater_than_B),
        .A_less_than_B(A_less_than_B),
        .equal(equal)
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
            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = B (170 == 170)", test_num);
            reset_dut();
            A = 8'd170; B = 8'd170;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A > B (200 > 100)", test_num);
            reset_dut();
            A = 8'd200; B = 8'd100;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A < B (50 < 150)", test_num);
            reset_dut();
            A = 8'd50; B = 8'd150;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = B (255 == 255)", test_num);
            reset_dut();
            A = 8'hFF; B = 8'hFF;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A > B (MSB Difference: 128 > 127)", test_num);
            reset_dut();
            A = 8'b10000000; B = 8'b01111111;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A < B (LSB Difference: 1 < 2)", test_num);
            reset_dut();
            A = 8'd1; B = 8'd2;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A > B (255 > 0)", test_num);
            reset_dut();
            A = 8'd255; B = 8'd0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
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
        input expected_A_greater_than_B;
        input expected_A_less_than_B;
        input expected_equal;
        begin
            if (expected_A_greater_than_B === (expected_A_greater_than_B ^ A_greater_than_B ^ expected_A_greater_than_B) &&
                expected_A_less_than_B === (expected_A_less_than_B ^ A_less_than_B ^ expected_A_less_than_B) &&
                expected_equal === (expected_equal ^ equal ^ expected_equal)) begin
                $display("PASS");
                $display("  Outputs: A_greater_than_B=%b, A_less_than_B=%b, equal=%b",
                         A_greater_than_B, A_less_than_B, equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_greater_than_B=%b, A_less_than_B=%b, equal=%b",
                         expected_A_greater_than_B, expected_A_less_than_B, expected_equal);
                $display("  Got:      A_greater_than_B=%b, A_less_than_B=%b, equal=%b",
                         A_greater_than_B, A_less_than_B, equal);
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
        $dumpvars(0,A, B, clk, A_greater_than_B, A_less_than_B, equal);
    end

endmodule
