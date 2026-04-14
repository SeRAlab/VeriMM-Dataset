`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Y1;
    wire Y2;

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
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Y1(Y1),
        .Y2(Y2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs 0", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 0; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs 1 (NAND logic should trigger)", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only A and B are 1", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 1; B = 1; C = 0; D = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only C and D are 1", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 0; B = 0; C = 1; D = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A, B, and C are 1, D is 0", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 1; B = 1; C = 1; D = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating inputs", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 1; B = 0; C = 1; D = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single input high (D)", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 0; B = 0; C = 0; D = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single input high (A)", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 1; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three inputs high (B, C, D)", test_num);
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            A = 0; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_Y1;
        input expected_Y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y2=%b",
                         Y1, Y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y2=%b",
                         expected_Y1, expected_Y2);
                $display("  Got:      Y1=%b, Y2=%b",
                         Y1, Y2);
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
