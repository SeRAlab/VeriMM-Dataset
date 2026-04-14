`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
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
        .C(C),
        .D(D),
        .EQ(EQ),
        .GT(GT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd5; B = 4'd2; C = 4'd0; D = 4'd0;
        $display("Test %0d: A > B condition (A=5, B=2, C=0, D=0)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd2; B = 4'd5; C = 4'd15; D = 4'd15;
        $display("Test %0d: A < B condition (A=2, B=5, C=15, D=15)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd10; C = 4'd8; D = 4'd3;
        $display("Test %0d: A == B and C > D condition (A=10, B=10, C=8, D=3)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd10; C = 4'd3; D = 4'd8;
        $display("Test %0d: A == B and C < D condition (A=10, B=10, C=3, D=8)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd7; B = 4'd7; C = 4'd12; D = 4'd12;
        $display("Test %0d: A == B and C == D condition (A=7, B=7, C=12, D=12)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd0; C = 4'd0; D = 4'd0;
        $display("Test %0d: All zeros boundary (A=0, B=0, C=0, D=0)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd15; C = 4'd15; D = 4'd15;
        $display("Test %0d: All ones boundary (A=15, B=15, C=15, D=15)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd0; C = 4'd0; D = 4'd15;
        $display("Test %0d: A=max, B=min (A=15, B=0, C=0, D=15)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'd1; B = 4'd1; C = 4'd15; D = 4'd0;
        $display("Test %0d: A=B, C=max, D=min (A=1, B=1, C=15, D=0)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd15; C = 4'd15; D = 4'd0;
        $display("Test %0d: A=min, B=max (A=0, B=15, C=15, D=0)", test_num);
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
        input expected_EQ;
        input expected_GT;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
