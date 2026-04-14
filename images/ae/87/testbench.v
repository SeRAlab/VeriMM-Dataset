`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg reset;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num1(num1),
        .num2(num2),
        .reset(reset),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            num1 = 0;
            num2 = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition (No Carry)", test_num);
            reset_dut();
            num1 = 8'd40;
            num2 = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd90);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition resulting in Carry-Out", test_num);
            reset_dut();
            num1 = 8'd200;
            num2 = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd300);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry usage from previous operation", test_num);
            reset_dut();

            num1 = 8'hFF;
            num2 = 8'h01;
            @(posedge clk);

            num1 = 8'd10;
            num2 = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation with max values", test_num);
            reset_dut();

            num1 = 8'hFF;
            num2 = 8'hFF;
            @(posedge clk);

            num1 = 8'hFF;
            num2 = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h1FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset clearing carry state", test_num);
            reset_dut();

            num1 = 8'hFF;
            num2 = 8'h01;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;

            num1 = 8'd5;
            num2 = 8'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd10);
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
        input [8:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,clk, num1, num2, reset, sum);
    end

endmodule
