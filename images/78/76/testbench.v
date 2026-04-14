`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs LOW", test_num);
            A1 = 1'b0; A2 = 1'b0; B1 = 1'b0;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: B1 HIGH (A1, A2 LOW)", test_num);
            A1 = 1'b0; A2 = 1'b0; B1 = 1'b1;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: A2 HIGH (A1, B1 LOW)", test_num);
            A1 = 1'b0; A2 = 1'b1; B1 = 1'b0;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: A2 and B1 HIGH", test_num);
            A1 = 1'b0; A2 = 1'b1; B1 = 1'b1;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: A1 HIGH (A2, B1 LOW)", test_num);
            A1 = 1'b1; A2 = 1'b0; B1 = 1'b0;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: A1 and B1 HIGH", test_num);
            A1 = 1'b1; A2 = 1'b0; B1 = 1'b1;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: A1 and A2 HIGH", test_num);
            A1 = 1'b1; A2 = 1'b1; B1 = 1'b0;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: All inputs HIGH", test_num);
            A1 = 1'b1; A2 = 1'b1; B1 = 1'b1;
            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            #1;

            check_outputs(1'b1);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
