`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] result;

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
        $display("Test Case %0d: A=0, B=0", test_num);
        A = 4'd0;
        B = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=15, B=0", test_num);
        A = 4'd15;
        B = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=0, B=15", test_num);
        A = 4'd0;
        B = 4'd15;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=1, B=1", test_num);
        A = 4'd1;
        B = 4'd1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=15, B=1", test_num);
        A = 4'd15;
        B = 4'd1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=1, B=15", test_num);
        A = 4'd1;
        B = 4'd15;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=15, B=15 (Maximum Value)", test_num);
        A = 4'd15;
        B = 4'd15;
        #1;

        check_outputs(8'd225);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=10, B=10", test_num);
        A = 4'd10;
        B = 4'd10;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=3, B=7", test_num);
        A = 4'd3;
        B = 4'd7;
        #1;

        check_outputs(8'd21);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=12, B=4 (Power of 2 check)", test_num);
        A = 4'd12;
        B = 4'd4;
        #1;

        check_outputs(8'd48);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=5, B=9", test_num);
        A = 4'd5;
        B = 4'd9;
        #1;

        check_outputs(8'd45);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=14, B=11", test_num);
        A = 4'd14;
        B = 4'd11;
        #1;

        check_outputs(8'd154);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_result;
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
