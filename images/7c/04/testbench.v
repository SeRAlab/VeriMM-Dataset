`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [24:0] in_data;
    reg [8:0] kernel;
    reg reset;
    wire [8:0] out_data;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .kernel(kernel),
        .reset(reset),
        .out_data(out_data),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_data = 0;
            kernel = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            in_data = 25'h0;
            kernel = 9'h0;
            @(posedge clk);

            wait(valid === 1);
            #1;

            check_outputs(9'h000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            in_data = 25'h1FFFFFF;
            kernel = 9'h1FF;
            @(posedge clk);
            wait(valid === 1);
            #1;

            check_outputs(9'h1FF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Corner Match", test_num);
            reset_dut();
            in_data = 25'h0000001;
            kernel  = 9'h001;
            @(posedge clk);
            wait(valid === 1);
            #1;

            check_outputs(9'h001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Universal Pivot Match", test_num);
            reset_dut();
            in_data = (25'h1 << 12);
            kernel  = 9'h010;
            @(posedge clk);
            wait(valid === 1);
            #1;

            check_outputs(9'h1FF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bottom-Right Match", test_num);
            reset_dut();
            in_data = (25'h1 << 24);
            kernel  = 9'h100;
            @(posedge clk);
            wait(valid === 1);
            #1;

            check_outputs(9'h100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Overlap", test_num);
            reset_dut();
            in_data = 25'h0000001;
            kernel  = 9'h100;
            @(posedge clk);
            wait(valid === 1);
            #1;

            check_outputs(9'h000, 1'b1);
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
        input [8:0] expected_out_data;
        input expected_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, valid=%b",
                         out_data, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, valid=%b",
                         expected_out_data, expected_valid);
                $display("  Got:      out_data=%h, valid=%b",
                         out_data, valid);
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
        $dumpvars(0,clk, in_data, kernel, reset, out_data, valid);
    end

endmodule
