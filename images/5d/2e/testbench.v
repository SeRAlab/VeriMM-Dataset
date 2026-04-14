`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] efect;
    wire efect0;
    wire efect1;
    wire efect2;
    wire efect3;
    wire efect4;
    wire efect5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .efect(efect),
        .efect0(efect0),
        .efect1(efect1),
        .efect2(efect2),
        .efect3(efect3),
        .efect4(efect4),
        .efect5(efect5)
    );
    task testcase001;

    begin
        test_num = 1;
        efect = 7'd48;
        $display("Testcase %0d: Testing input 48 (Expected efect0=1)", test_num);
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        efect = 7'd49;
        $display("Testcase %0d: Testing input 49 (Expected efect1=1)", test_num);
        #1;

        check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        efect = 7'd50;
        $display("Testcase %0d: Testing input 50 (Expected efect2=1)", test_num);
        #1;

        check_outputs(0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        efect = 7'd51;
        $display("Testcase %0d: Testing input 51 (Expected efect3=1)", test_num);
        #1;

        check_outputs(0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        efect = 7'd52;
        $display("Testcase %0d: Testing input 52 (Expected efect4=1)", test_num);
        #1;

        check_outputs(0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        efect = 7'd53;
        $display("Testcase %0d: Testing input 53 (Expected efect5=1)", test_num);
        #1;

        check_outputs(0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        efect = 7'd47;
        $display("Testcase %0d: Testing input 47 (Expected default: efect0=1)", test_num);
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        efect = 7'd54;
        $display("Testcase %0d: Testing input 54 (Expected default: efect0=1)", test_num);
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        efect = 7'd0;
        $display("Testcase %0d: Testing input 0 (Expected default: efect0=1)", test_num);
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        efect = 7'd127;
        $display("Testcase %0d: Testing input 127 (Expected default: efect0=1)", test_num);
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
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
        input expected_efect0;
        input expected_efect1;
        input expected_efect2;
        input expected_efect3;
        input expected_efect4;
        input expected_efect5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_efect0 === (expected_efect0 ^ efect0 ^ expected_efect0) &&
                expected_efect1 === (expected_efect1 ^ efect1 ^ expected_efect1) &&
                expected_efect2 === (expected_efect2 ^ efect2 ^ expected_efect2) &&
                expected_efect3 === (expected_efect3 ^ efect3 ^ expected_efect3) &&
                expected_efect4 === (expected_efect4 ^ efect4 ^ expected_efect4) &&
                expected_efect5 === (expected_efect5 ^ efect5 ^ expected_efect5)) begin
                $display("PASS");
                $display("  Outputs: efect0=%b, efect1=%b, efect2=%b, efect3=%b, efect4=%b, efect5=%b",
                         efect0, efect1, efect2, efect3, efect4, efect5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: efect0=%b, efect1=%b, efect2=%b, efect3=%b, efect4=%b, efect5=%b",
                         expected_efect0, expected_efect1, expected_efect2, expected_efect3, expected_efect4, expected_efect5);
                $display("  Got:      efect0=%b, efect1=%b, efect2=%b, efect3=%b, efect4=%b, efect5=%b",
                         efect0, efect1, efect2, efect3, efect4, efect5);
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
