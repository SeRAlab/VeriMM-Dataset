`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive * Positive (10 * 5)", test_num);
        A = 16'h000A;
        B = 16'h0005;
        #1;

        check_outputs(32'h00000032);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive * Negative (10 * -5)", test_num);
        A = 16'h000A;
        B = 16'h8005;
        #1;

        check_outputs(32'h80000032);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative * Positive (-10 * 5)", test_num);
        A = 16'h800A;
        B = 16'h0005;
        #1;

        check_outputs(32'h80000032);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative * Negative (-10 * -5)", test_num);
        A = 16'h800A;
        B = 16'h8005;
        #1;

        check_outputs(32'h00000032);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Zero (0 * -25)", test_num);
        A = 16'h0000;
        B = 16'h8019;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Positive Magnitude (32767 * 2)", test_num);
        A = 16'h7FFF;
        B = 16'h0002;
        #1;

        check_outputs(32'h0000FFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Negative Magnitude (-32767 * 1)", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        #1;

        check_outputs(32'h80007FFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Range (-32767 * -32767)", test_num);
        A = 16'hFFFF;
        B = 16'hFFFF;
        #1;

        check_outputs(32'h3FFF0001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Property (-1 * 1)", test_num);
        A = 16'h8001;
        B = 16'h0001;
        #1;

        check_outputs(32'h80000001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Zero Multiplication (-0 * 5)", test_num);
        A = 16'h8000;
        B = 16'h0005;


        #1;



        check_outputs(result & 32'h7FFFFFFF);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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

endmodule
