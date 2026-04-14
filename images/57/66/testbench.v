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
    wire Y;

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
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs Low", test_num);
            A = 0; B = 0; C = 0; D = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single input High (A)", test_num);
            A = 1; B = 0; C = 0; D = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single input High (B)", test_num);
            A = 0; B = 1; C = 0; D = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Single input High (C)", test_num);
            A = 0; B = 0; C = 1; D = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Single input High (D)", test_num);
            A = 0; B = 0; C = 0; D = 1;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Three inputs High (A, B, C)", test_num);
            A = 1; B = 1; C = 1; D = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Three inputs High (B, C, D)", test_num);
            A = 0; B = 1; C = 1; D = 1;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Three inputs High (A, C, D)", test_num);
            A = 1; B = 0; C = 1; D = 1;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Three inputs High (A, B, D)", test_num);
            A = 1; B = 1; C = 0; D = 1;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: All inputs High (NAND logic 0)", test_num);
            A = 1; B = 1; C = 1; D = 1;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Toggle check", test_num);
            A = 1; B = 1; C = 1; D = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #10;
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1'b0);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
