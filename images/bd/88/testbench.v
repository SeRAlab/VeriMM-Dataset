`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg C;
    reg [3:0] O;
    wire B;
    wire [3:0] D;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .C(C),
        .O(O),
        .B(B),
        .D(D),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition - O=5, A=3, C=1", test_num);
        O = 4'd5;
        A = 4'd3;
        C = 1'b1;

        #1;


        check_outputs(1'b0, 4'd0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with wrap - O=12, A=6, C=1", test_num);
        O = 4'd12;
        A = 4'd6;
        C = 1'b1;

        #1;


        check_outputs(1'b0, 4'd0, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition - O=0, A=0, C=1", test_num);
        O = 4'd0;
        A = 4'd0;
        C = 1'b1;

        #1;


        check_outputs(1'b0, 4'd0, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (O > A) - O=10, A=4, C=0", test_num);
        O = 4'd10;
        A = 4'd4;
        C = 1'b0;

        #1;


        check_outputs(1'b0, 4'd6, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (O < A) - O=3, A=7, C=0", test_num);
        O = 4'd3;
        A = 4'd7;
        C = 1'b0;

        #1;


        check_outputs(1'b1, 4'd12, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (O = A) - O=8, A=8, C=0", test_num);
        O = 4'd8;
        A = 4'd8;
        C = 1'b0;

        #1;


        check_outputs(1'b0, 4'd0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction - O=0, A=15, C=0", test_num);
        O = 4'd0;
        A = 4'd15;
        C = 1'b0;

        #1;


        check_outputs(1'b1, 4'd1, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition - O=15, A=15, C=1", test_num);
        O = 4'd15;
        A = 4'd15;
        C = 1'b1;

        #1;


        check_outputs(1'b0, 4'd0, 4'd14);
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
        input expected_B;
        input [3:0] expected_D;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_D === (expected_D ^ D ^ expected_D) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: B=%b, D=%h, S=%h",
                         B, D, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%b, D=%h, S=%h",
                         expected_B, expected_D, expected_S);
                $display("  Got:      B=%b, D=%h, S=%h",
                         B, D, S);
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
