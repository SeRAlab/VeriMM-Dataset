`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire OV;
    wire [3:0] S;
    wire UF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .OV(OV),
        .S(S),
        .UF(UF)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (A=3, B=4, C=0) - Expect Sum=7, OV=0, UF=0", test_num);
            A = 4'd3; B = 4'd4; C = 1'b0;
            #1;

            check_outputs(1'b0, 4'd7, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (A=10, B=5, C=0) - Expect Sum=15, OV=0, UF=0", test_num);
            A = 4'd10; B = 4'd5; C = 1'b0;
            #1;

            check_outputs(1'b0, 4'd15, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (A=8, B=8, C=0) - Expect Sum=0, OV=1, UF=0", test_num);
            A = 4'd8; B = 4'd8; C = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (A=15, B=15, C=0) - Expect Sum=0, OV=1, UF=0", test_num);
            A = 4'd15; B = 4'd15; C = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (A=12, B=4, C=1) - Expect Diff=8, OV=0, UF=0", test_num);
            A = 4'd12; B = 4'd4; C = 1'b1;
            #1;

            check_outputs(1'b0, 4'd8, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (A=7, B=7, C=1) - Expect Diff=0, OV=0, UF=0", test_num);
            A = 4'd7; B = 4'd7; C = 1'b1;
            #1;

            check_outputs(1'b0, 4'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (A=4, B=5, C=1) - Expect Sum=0, OV=0, UF=1", test_num);
            A = 4'd4; B = 4'd5; C = 1'b1;
            #1;

            check_outputs(1'b0, 4'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (A=0, B=15, C=1) - Expect Sum=0, OV=0, UF=1", test_num);
            A = 4'd0; B = 4'd15; C = 1'b1;
            #1;

            check_outputs(1'b0, 4'd0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition (A=0, B=0, C=0) - Expect Sum=0, OV=0, UF=0", test_num);
            A = 4'd0; B = 4'd0; C = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Edge (A=15, B=1, C=0) - Expect Sum=0, OV=1, UF=0", test_num);
            A = 4'd15; B = 4'd1; C = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0, 1'b0);
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
        testcase011();
        
        
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
        input expected_OV;
        input [3:0] expected_S;
        input expected_UF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OV === (expected_OV ^ OV ^ expected_OV) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_UF === (expected_UF ^ UF ^ expected_UF)) begin
                $display("PASS");
                $display("  Outputs: OV=%b, S=%h, UF=%b",
                         OV, S, UF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OV=%b, S=%h, UF=%b",
                         expected_OV, expected_S, expected_UF);
                $display("  Got:      OV=%b, S=%h, UF=%b",
                         OV, S, UF);
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
