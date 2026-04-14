`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] lookup;
    wire [15:0] duration;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lookup(lookup),
        .duration(duration)
    );
    task testcase001;

    begin
        test_num = 1;
        lookup = 4'h0;
        $display("Test Case %0d: Semi-quaver mapping", test_num);
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        lookup = 4'h1;
        $display("Test Case %0d: Quaver mapping", test_num);
        #1;

        check_outputs(16'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        lookup = 4'h2;
        $display("Test Case %0d: Crotchet mapping", test_num);
        #1;

        check_outputs(16'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        lookup = 4'h3;
        $display("Test Case %0d: Minim mapping", test_num);
        #1;

        check_outputs(16'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        lookup = 4'h4;
        $display("Test Case %0d: Semibreve mapping", test_num);
        #1;

        check_outputs(16'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        lookup = 4'h5;
        $display("Test Case %0d: Breve mapping", test_num);
        #1;

        check_outputs(16'd32);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        lookup = 4'h6;
        $display("Test Case %0d: Tuplet mapping A", test_num);
        #1;

        check_outputs(16'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        lookup = 4'h7;
        $display("Test Case %0d: Tuplet mapping B", test_num);
        #1;

        check_outputs(16'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        lookup = 4'hE;
        $display("Test Case %0d: Undefined code default check", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        lookup = 4'hF;
        $display("Test Case %0d: Boundary check (lookup=15)", test_num);
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_duration;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_duration === (expected_duration ^ duration ^ expected_duration)) begin
                $display("PASS");
                $display("  Outputs: duration=%h",
                         duration);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: duration=%h",
                         expected_duration);
                $display("  Got:      duration=%h",
                         duration);
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
