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
    wire X;

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
        .X(X)
    );
    task set_power_rails;

        begin
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b1;
            VNB  = 1'b0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            set_power_rails();
            A_N = 1'b0; B_N = 1'b0; C = 1'b1; D = 1'b1;
            $display("Testcase %0d: Testing Match Condition (0,0,1,1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            set_power_rails();
            A_N = 1'b0; B_N = 1'b0; C = 1'b0; D = 1'b0;
            $display("Testcase %0d: Testing All Low (0,0,0,0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            set_power_rails();
            A_N = 1'b1; B_N = 1'b1; C = 1'b1; D = 1'b1;
            $display("Testcase %0d: Testing All High (1,1,1,1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            set_power_rails();
            A_N = 1'b1; B_N = 1'b0; C = 1'b1; D = 1'b1;
            $display("Testcase %0d: Testing Partial Match A_N=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            set_power_rails();
            A_N = 1'b0; B_N = 1'b1; C = 1'b1; D = 1'b1;
            $display("Testcase %0d: Testing Partial Match B_N=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            set_power_rails();
            A_N = 1'b0; B_N = 1'b0; C = 1'b0; D = 1'b1;
            $display("Testcase %0d: Testing Partial Match C=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            set_power_rails();
            A_N = 1'b0; B_N = 1'b0; C = 1'b1; D = 1'b0;
            $display("Testcase %0d: Testing Partial Match D=0", test_num);
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
