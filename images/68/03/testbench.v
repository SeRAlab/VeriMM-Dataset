`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire equal;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .equal(equal),
        .less(less)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        in = 32'h00000000;

        #1;


        check_outputs(1, 0);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones", test_num);
        in = 32'hFFFFFFFF;

        #1;


        check_outputs(1, 0);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Equal Non-Zero Values", test_num);
        in = 32'h12341234;

        #1;


        check_outputs(1, 0);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Upper Less Than Lower (Small Difference)", test_num);
        in = 32'h00010002;

        #1;


        check_outputs(0, 1);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Upper Greater Than Lower (Small Difference)", test_num);
        in = 32'h00020001;

        #1;


        check_outputs(0, 0);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Upper Minimal, Lower Maximal", test_num);
        in = 32'h0000FFFF;

        #1;


        check_outputs(0, 1);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Upper Maximal, Lower Minimal", test_num);
        in = 32'hFFFF0000;

        #1;


        check_outputs(0, 0);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: MSB Comparison (Upper < Lower)", test_num);
        in = 32'h7FFF8000;

        #1;


        check_outputs(0, 1);
    end
    endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: MSB Comparison (Upper > Lower)", test_num);
        in = 32'h80007FFF;

        #1;


        check_outputs(0, 0);
    end
    endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Alternating Bit Pattern A", test_num);
        in = 32'h5555AAAA;

        #1;


        check_outputs(0, 1);
    end
    endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case %0d: Alternating Bit Pattern B", test_num);
        in = 32'hAAAA5555;

        #1;


        check_outputs(0, 0);
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
        testcase011();
        
        
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
        input expected_equal;
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, less=%b",
                         equal, less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, less=%b",
                         expected_equal, expected_less);
                $display("  Got:      equal=%b, less=%b",
                         equal, less);
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
