`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Data0x0;
    reg Data0x1;
    reg Data0x2;
    reg Data0x3;
    reg Data1x0;
    reg Data1x1;
    reg Data1x2;
    reg Data1x3;
    reg Sel0;
    wire Result0;
    wire Result1;
    wire Result2;
    wire Result3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data0x0(Data0x0),
        .Data0x1(Data0x1),
        .Data0x2(Data0x2),
        .Data0x3(Data0x3),
        .Data1x0(Data1x0),
        .Data1x1(Data1x1),
        .Data1x2(Data1x2),
        .Data1x3(Data1x3),
        .Sel0(Sel0),
        .Result0(Result0),
        .Result1(Result1),
        .Result2(Result2),
        .Result3(Result3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sel0=0, Data0=4'b1111, Data1=4'b0000", test_num);
            Sel0 = 0;
            Data0x0 = 1; Data0x1 = 1; Data0x2 = 1; Data0x3 = 1;
            Data1x0 = 0; Data1x1 = 0; Data1x2 = 0; Data1x3 = 0;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sel0=1, Data0=4'b1111, Data1=4'b0000", test_num);
            Sel0 = 1;
            Data0x0 = 1; Data0x1 = 1; Data0x2 = 1; Data0x3 = 1;
            Data1x0 = 0; Data1x1 = 0; Data1x2 = 0; Data1x3 = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sel0=0, Data0=4'b1010, Data1=4'b0101", test_num);
            Sel0 = 0;
            Data0x0 = 1; Data0x1 = 0; Data0x2 = 1; Data0x3 = 0;
            Data1x0 = 0; Data1x1 = 1; Data1x2 = 0; Data1x3 = 1;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sel0=1, Data0=4'b1010, Data1=4'b0101", test_num);
            Sel0 = 1;
            Data0x0 = 1; Data0x1 = 0; Data0x2 = 1; Data0x3 = 0;
            Data1x0 = 0; Data1x1 = 1; Data1x2 = 0; Data1x3 = 1;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sel0=0, Data0=4'b0110, Data1=4'b1001", test_num);
            Sel0 = 0;
            Data0x0 = 0; Data0x1 = 1; Data0x2 = 1; Data0x3 = 0;
            Data1x0 = 1; Data1x1 = 0; Data1x2 = 0; Data1x3 = 1;
            #1;

            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sel0=1, Data0=4'b0110, Data1=4'b1001", test_num);
            Sel0 = 1;
            Data0x0 = 0; Data0x1 = 1; Data0x2 = 1; Data0x3 = 0;
            Data1x0 = 1; Data1x1 = 0; Data1x2 = 0; Data1x3 = 1;
            #1;

            check_outputs(1, 0, 0, 1);
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
        input expected_Result0;
        input expected_Result1;
        input expected_Result2;
        input expected_Result3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result0 === (expected_Result0 ^ Result0 ^ expected_Result0) &&
                expected_Result1 === (expected_Result1 ^ Result1 ^ expected_Result1) &&
                expected_Result2 === (expected_Result2 ^ Result2 ^ expected_Result2) &&
                expected_Result3 === (expected_Result3 ^ Result3 ^ expected_Result3)) begin
                $display("PASS");
                $display("  Outputs: Result0=%b, Result1=%b, Result2=%b, Result3=%b",
                         Result0, Result1, Result2, Result3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result0=%b, Result1=%b, Result2=%b, Result3=%b",
                         expected_Result0, expected_Result1, expected_Result2, expected_Result3);
                $display("  Got:      Result0=%b, Result1=%b, Result2=%b, Result3=%b",
                         Result0, Result1, Result2, Result3);
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
