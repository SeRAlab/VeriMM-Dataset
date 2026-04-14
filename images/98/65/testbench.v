`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 8'h00;


            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0x00)", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (0xFF)", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern A (0xAA)", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern B (0x55)", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit (0x01)", test_num);
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Nibble Data (0xF0)", test_num);
            reset_dut();
            data_in = 8'hF0;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern (0xC3)", test_num);
            reset_dut();
            data_in = 8'hC3;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC3, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_error;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b",
                         data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b",
                         expected_data_out, expected_error);
                $display("  Got:      data_out=%h, error=%b",
                         data_out, error);
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
        $dumpvars(0,clk, data_in, data_out, error);
    end

endmodule
