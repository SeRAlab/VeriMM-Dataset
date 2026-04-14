`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg iA;
    reg iB;
    reg iC;
    wire oC;
    wire oS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iA(iA),
        .iB(iB),
        .iC(iC),
        .oC(oC),
        .oS(oS)
    );
    task testcase001;

        begin
            test_num = 1;
            iA = 0; iB = 0; iC = 0;
            $display("Test %0d: iA=0, iB=0, iC=0", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            iA = 0; iB = 0; iC = 1;
            $display("Test %0d: iA=0, iB=0, iC=1", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            iA = 0; iB = 1; iC = 0;
            $display("Test %0d: iA=0, iB=1, iC=0", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            iA = 0; iB = 1; iC = 1;
            $display("Test %0d: iA=0, iB=1, iC=1", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            iA = 1; iB = 0; iC = 0;
            $display("Test %0d: iA=1, iB=0, iC=0", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            iA = 1; iB = 0; iC = 1;
            $display("Test %0d: iA=1, iB=0, iC=1", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            iA = 1; iB = 1; iC = 0;
            $display("Test %0d: iA=1, iB=1, iC=0", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            iA = 1; iB = 1; iC = 1;
            $display("Test %0d: iA=1, iB=1, iC=1", test_num);
            #1;

            check_outputs(1, 1);
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
        input expected_oC;
        input expected_oS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oC === (expected_oC ^ oC ^ expected_oC) &&
                expected_oS === (expected_oS ^ oS ^ expected_oS)) begin
                $display("PASS");
                $display("  Outputs: oC=%b, oS=%b",
                         oC, oS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oC=%b, oS=%b",
                         expected_oC, expected_oS);
                $display("  Got:      oC=%b, oS=%b",
                         oC, oS);
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
