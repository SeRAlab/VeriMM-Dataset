`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire [8:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .C(C)
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
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition (15 + 20 = 35)", test_num);
        reset_dut();
        A = 8'd15;
        B = 8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'd35);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero inputs", test_num);
        reset_dut();
        A = 8'h00;
        B = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max value no overflow (127 + 128 = 255)", test_num);
        reset_dut();
        A = 8'd127;
        B = 8'd128;
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum overflow (128 + 128 = 256)", test_num);
        reset_dut();
        A = 8'd128;
        B = 8'd128;
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow (200 + 100 = 300)", test_num);
        reset_dut();
        A = 8'd200;
        B = 8'd100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'h12C);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum sum (255 + 255 = 510)", test_num);
        reset_dut();
        A = 8'hFF;
        B = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'h1FE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Edge case overflow (255 + 1 = 256)", test_num);
        reset_dut();
        A = 8'd255;
        B = 8'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'h100);
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
        input [8:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, rst, C);
    end

endmodule
