`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_data;
    reg in_valid;
    reg rst;
    wire [31:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .rst(rst),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            in_data = 0;
            in_valid = 0;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset State Verification");
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Valid Transfer");
            reset_dut();
            in_data = 32'hDEADBEEF;
            in_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: out_valid Deassertion when in_valid is Low");
            reset_dut();

            in_data = 32'h12345678;
            in_valid = 1;
            @(posedge clk);

            #1 in_valid = 0;
            in_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;



            #1;




            check_outputs(out_data, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Back-to-back Valid Transfers");
            reset_dut();
            in_valid = 1;
            in_data = 32'hAAAA_AAAA;
            @(posedge clk);
            #1 in_data = 32'h5555_5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555_5555, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Reset Dominance");
            reset_dut();
            in_data = 32'hBCBC_BCBC;
            in_valid = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Maximum Data Value Transfer");
            reset_dut();
            in_data = 32'hFFFF_FFFF;
            in_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b1);
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
        input [31:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, out_valid=%b",
                         out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, out_valid=%b",
                         expected_out_data, expected_out_valid);
                $display("  Got:      out_data=%h, out_valid=%b",
                         out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, rst, out_data, out_valid);
    end

endmodule
