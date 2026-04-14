`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A_N;
    reg B_N;
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
        .A_N(A_N),
        .B_N(B_N),
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
            VGND = 0; VNB = 0; VPWR = 1; VPB = 1;
            $display("Test %0d: All inputs active (A_N=0, B_N=0, C=1, D=1)", test_num);
            A_N = 1'b0;
            B_N = 1'b0;
            C   = 1'b1;
            D   = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: A_N high (inactive)", test_num);
            A_N = 1'b1;
            B_N = 1'b0;
            C   = 1'b1;
            D   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: B_N high (inactive)", test_num);
            A_N = 1'b0;
            B_N = 1'b1;
            C   = 1'b1;
            D   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: C low (inactive)", test_num);
            A_N = 1'b0;
            B_N = 1'b0;
            C   = 1'b0;
            D   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: D low (inactive)", test_num);
            A_N = 1'b0;
            B_N = 1'b0;
            C   = 1'b1;
            D   = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiple inputs inactive", test_num);
            A_N = 1'b1;
            B_N = 1'b1;
            C   = 1'b0;
            D   = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Verify NAND behavior via A_N toggle while others active", test_num);
            B_N = 1'b0; C = 1'b1; D = 1'b1;
            A_N = 1'b1; #5;
            A_N = 1'b0; #5;
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
