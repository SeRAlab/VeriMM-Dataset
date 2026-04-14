`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg inA;
    reg inB;
    reg select;
    wire outC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inA(inA),
        .inB(inB),
        .select(select),
        .outC(outC)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select inA (select=1), inA=1, inB=0", test_num);
            select = 1'b1;
            inA = 1'b1;
            inB = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select inA (select=1), inA=0, inB=1", test_num);
            select = 1'b1;
            inA = 1'b0;
            inB = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select inB (select=0), inA=1, inB=0", test_num);
            select = 1'b0;
            inA = 1'b1;
            inB = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select inB (select=0), inA=0, inB=1", test_num);
            select = 1'b0;
            inA = 1'b0;
            inB = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select inA (select=1), both inputs high", test_num);
            select = 1'b1;
            inA = 1'b1;
            inB = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select inB (select=0), both inputs low", test_num);
            select = 1'b0;
            inA = 1'b0;
            inB = 1'b0;
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
        input expected_outC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outC === (expected_outC ^ outC ^ expected_outC)) begin
                $display("PASS");
                $display("  Outputs: outC=%b",
                         outC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outC=%b",
                         expected_outC);
                $display("  Got:      outC=%b",
                         outC);
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
