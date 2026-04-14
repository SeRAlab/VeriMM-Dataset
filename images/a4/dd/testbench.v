`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] btn;
    wire [3:0] anode;
    wire [6:0] cathode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn(btn),
        .anode(anode),
        .cathode(cathode)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: No buttons pressed");
            btn = 4'b0000;
            #1;

            check_outputs(4'b0000, 7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Press Button 0");
            btn = 4'b0001;
            #1;

            check_outputs(4'b0001, 7'b0000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Press Button 1");
            btn = 4'b0010;
            #1;

            check_outputs(4'b0010, 7'b0000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Press Button 2");
            btn = 4'b0100;
            #1;

            check_outputs(4'b0100, 7'b0000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Press Button 3");
            btn = 4'b1000;
            #1;

            check_outputs(4'b1000, 7'b0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Multiple buttons (0 and 3)");
            btn = 4'b1001;
            #1;

            check_outputs(4'b1001, 7'b0000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: All buttons pressed");
            btn = 4'b1111;
            #1;

            check_outputs(4'b1111, 7'b0000000);
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
        input [3:0] expected_anode;
        input [6:0] expected_cathode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_anode === (expected_anode ^ anode ^ expected_anode) &&
                expected_cathode === (expected_cathode ^ cathode ^ expected_cathode)) begin
                $display("PASS");
                $display("  Outputs: anode=%h, cathode=%h",
                         anode, cathode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anode=%h, cathode=%h",
                         expected_anode, expected_cathode);
                $display("  Got:      anode=%h, cathode=%h",
                         anode, cathode);
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
