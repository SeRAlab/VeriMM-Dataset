`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    reg Sel0;
    reg Sel1;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .Sel0(Sel0),
        .Sel1(Sel1),
        .O(O)
    );
    task testcase001;

        begin
            test_num = 1;
            Sel0 = 0; Sel1 = 0;
            I0 = 0; I1 = 1; I2 = 1; I3 = 1;
            $display("Test %0d: Select I0 (Sel0=0, Sel1=0), I0=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Sel0 = 0; Sel1 = 0;
            I0 = 1; I1 = 0; I2 = 0; I3 = 0;
            $display("Test %0d: Select I0 (Sel0=0, Sel1=0), I0=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Sel0 = 0; Sel1 = 1;
            I0 = 1; I1 = 0; I2 = 1; I3 = 1;
            $display("Test %0d: Select I1 (Sel0=0, Sel1=1), I1=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Sel0 = 0; Sel1 = 1;
            I0 = 0; I1 = 1; I2 = 0; I3 = 0;
            $display("Test %0d: Select I1 (Sel0=0, Sel1=1), I1=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Sel0 = 1; Sel1 = 0;
            I0 = 1; I1 = 1; I2 = 0; I3 = 1;
            $display("Test %0d: Select I2 (Sel0=1, Sel1=0), I2=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Sel0 = 1; Sel1 = 0;
            I0 = 0; I1 = 0; I2 = 1; I3 = 0;
            $display("Test %0d: Select I2 (Sel0=1, Sel1=0), I2=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Sel0 = 1; Sel1 = 1;
            I0 = 1; I1 = 1; I2 = 1; I3 = 0;
            $display("Test %0d: Select I3 (Sel0=1, Sel1=1), I3=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Sel0 = 1; Sel1 = 1;
            I0 = 0; I1 = 0; I2 = 0; I3 = 1;
            $display("Test %0d: Select I3 (Sel0=1, Sel1=1), I3=1", test_num);
            #1;

            check_outputs(1);
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
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
