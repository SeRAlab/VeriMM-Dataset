`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pi0;
    reg pi1;
    reg pi2;
    reg pi3;
    reg pi4;
    reg pi5;
    reg pi6;
    reg pi7;
    reg pi8;
    wire po0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pi0(pi0),
        .pi1(pi1),
        .pi2(pi2),
        .pi3(pi3),
        .pi4(pi4),
        .pi5(pi5),
        .pi6(pi6),
        .pi7(pi7),
        .pi8(pi8),
        .po0(po0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All inputs 0", test_num);
            pi0 = 0; pi1 = 0; pi2 = 0;
            pi3 = 0; pi4 = 0; pi5 = 0;
            pi6 = 0; pi7 = 0; pi8 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All inputs 1", test_num);
            pi0 = 1; pi1 = 1; pi2 = 1;
            pi3 = 1; pi4 = 1; pi5 = 1;
            pi6 = 1; pi7 = 1; pi8 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Group 0 majority (1,1,1,0,0,0,0,0,0)", test_num);
            pi0 = 1; pi1 = 1; pi2 = 1;
            pi3 = 0; pi4 = 0; pi5 = 0;
            pi6 = 0; pi7 = 0; pi8 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Group 1 majority (0,0,0,1,1,1,0,0,0)", test_num);
            pi0 = 0; pi1 = 0; pi2 = 0;
            pi3 = 1; pi4 = 1; pi5 = 1;
            pi6 = 0; pi7 = 0; pi8 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Group 2 (w2) majority (0,0,0,0,0,0,1,1,1)", test_num);
            pi0 = 0; pi1 = 0; pi2 = 0;
            pi3 = 0; pi4 = 0; pi5 = 0;
            pi6 = 1; pi7 = 1; pi8 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Group 0 and 1 majority", test_num);
            pi0 = 1; pi1 = 1; pi2 = 0;
            pi3 = 1; pi4 = 1; pi5 = 0;
            pi6 = 0; pi7 = 0; pi8 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Group 0 and 2 majority", test_num);
            pi0 = 1; pi1 = 1; pi2 = 0;
            pi3 = 0; pi4 = 0; pi5 = 0;
            pi6 = 1; pi7 = 1; pi8 = 0;
            #1;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Bare majority in all groups", test_num);
            pi0 = 1; pi1 = 1; pi2 = 0;
            pi3 = 1; pi4 = 1; pi5 = 0;
            pi6 = 1; pi7 = 1; pi8 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating pattern 101101101", test_num);
            pi0 = 1; pi1 = 0; pi2 = 1;
            pi3 = 1; pi4 = 0; pi5 = 1;
            pi6 = 1; pi7 = 0; pi8 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Minority in all groups", test_num);
            pi0 = 1; pi1 = 0; pi2 = 0;
            pi3 = 0; pi4 = 1; pi5 = 0;
            pi6 = 0; pi7 = 0; pi8 = 1;
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
        input expected_po0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_po0 === (expected_po0 ^ po0 ^ expected_po0)) begin
                $display("PASS");
                $display("  Outputs: po0=%b",
                         po0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po0=%b",
                         expected_po0);
                $display("  Got:      po0=%b",
                         po0);
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
