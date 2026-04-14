`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] unextended;
    wire [31:0] extended;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .unextended(unextended),
        .extended(extended)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero input", test_num);
            unextended = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Maximum positive 16-bit value", test_num);
            unextended = 16'h7FFF;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Minimum negative 16-bit value (MSB is 1)", test_num);
            unextended = 16'h8000;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All ones (-1)", test_num);
            unextended = 16'hFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Arbitrary positive value", test_num);
            unextended = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Arbitrary negative value", test_num);
            unextended = 16'hA5A5;
            #1;

            check_outputs(32'hFFFFA5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Small positive value", test_num);
            unextended = 16'h0001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Small negative value", test_num);
            unextended = 16'hFFFE;
            #1;

            check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_extended;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extended === (expected_extended ^ extended ^ expected_extended)) begin
                $display("PASS");
                $display("  Outputs: extended=%h",
                         extended);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extended=%h",
                         expected_extended);
                $display("  Got:      extended=%h",
                         extended);
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
