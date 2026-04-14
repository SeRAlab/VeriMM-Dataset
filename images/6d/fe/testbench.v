`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] data_in;
    reg enable;
    reg rst;
    wire [15:0] code_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .rst(rst),
        .code_out(code_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 7'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Data (7'h00)", test_num);
            data_in = 7'h00;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All Ones Data (7'h7F)", test_num);
            data_in = 7'h7F;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h07FF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits Pattern (7'h55)", test_num);
            data_in = 7'h55;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h03D5, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits Pattern (7'h2A)", test_num);
            data_in = 7'h2A;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h042A, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Enable Signal Low Check", test_num);


            data_in = 7'h7F;
            enable = 1;
            @(posedge clk);
            #1;


            data_in = 7'h00;
            enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h07FF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Reset During Operation", test_num);

            data_in = 7'h55;
            enable = 1;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(16'h0000, 1'b0);
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
        input [15:0] expected_code_out;
        input expected_error;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, error=%b",
                         code_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, error=%b",
                         expected_code_out, expected_error);
                $display("  Got:      code_out=%h, error=%b",
                         code_out, error);
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
        $dumpvars(0,clk, data_in, enable, rst, code_out, error);
    end

endmodule
