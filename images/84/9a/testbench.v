`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg HH;
    reg MM;
    reg sel;
    wire up24;
    wire up24sv;
    wire up60;
    wire up60sv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HH(HH),
        .MM(MM),
        .sel(sel),
        .up24(up24),
        .up24sv(up24sv),
        .up60(up60),
        .up60sv(up60sv)
    );
    task testcase001;

    begin
        test_num = 1;
        HH = 0; MM = 0; sel = 0;

        #1;


        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        HH = 0; MM = 1; sel = 0;

        #1;


        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        HH = 1; MM = 0; sel = 0;

        #1;


        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        HH = 1; MM = 1; sel = 0;

        #1;


        check_outputs(1, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        HH = 0; MM = 0; sel = 1;

        #1;


        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        HH = 0; MM = 1; sel = 1;

        #1;


        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        HH = 1; MM = 0; sel = 1;

        #1;


        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        HH = 1; MM = 1; sel = 1;

        #1;


        check_outputs(0, 1, 0, 1);
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
        input expected_up24;
        input expected_up24sv;
        input expected_up60;
        input expected_up60sv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_up24 === (expected_up24 ^ up24 ^ expected_up24) &&
                expected_up24sv === (expected_up24sv ^ up24sv ^ expected_up24sv) &&
                expected_up60 === (expected_up60 ^ up60 ^ expected_up60) &&
                expected_up60sv === (expected_up60sv ^ up60sv ^ expected_up60sv)) begin
                $display("PASS");
                $display("  Outputs: up24=%b, up24sv=%b, up60=%b, up60sv=%b",
                         up24, up24sv, up60, up60sv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: up24=%b, up24sv=%b, up60=%b, up60sv=%b",
                         expected_up24, expected_up24sv, expected_up60, expected_up60sv);
                $display("  Got:      up24=%b, up24sv=%b, up60=%b, up60sv=%b",
                         up24, up24sv, up60, up60sv);
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
