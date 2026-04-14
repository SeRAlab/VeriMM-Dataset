`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Xminus;
    reg Xplus;
    reg Yminus;
    reg Yplus;
    wire touch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Xminus(Xminus),
        .Xplus(Xplus),
        .Yminus(Yminus),
        .Yplus(Yplus),
        .touch(touch)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All inputs zero", test_num);
        Xplus = 0; Xminus = 0; Yplus = 0; Yminus = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: X difference (Xplus high)", test_num);
        Xplus = 1; Xminus = 0; Yplus = 0; Yminus = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: X difference (Xminus high)", test_num);
        Xplus = 0; Xminus = 1; Yplus = 0; Yminus = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Y difference (Yplus high)", test_num);
        Xplus = 0; Xminus = 0; Yplus = 1; Yminus = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Y difference (Yminus high)", test_num);
        Xplus = 0; Xminus = 0; Yplus = 0; Yminus = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: All inputs high (Balanced)", test_num);
        Xplus = 1; Xminus = 1; Yplus = 1; Yminus = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: X difference with Y balanced", test_num);
        Xplus = 1; Xminus = 0; Yplus = 1; Yminus = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Y difference with X balanced low", test_num);
        Xplus = 0; Xminus = 0; Yplus = 0; Yminus = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Difference on both X and Y", test_num);
        Xplus = 1; Xminus = 0; Yplus = 0; Yminus = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: X balanced high, Y balanced low", test_num);
        Xplus = 1; Xminus = 1; Yplus = 0; Yminus = 0;
        #1;

        check_outputs(0);
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
        input expected_touch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_touch === (expected_touch ^ touch ^ expected_touch)) begin
                $display("PASS");
                $display("  Outputs: touch=%b",
                         touch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: touch=%b",
                         expected_touch);
                $display("  Got:      touch=%b",
                         touch);
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
