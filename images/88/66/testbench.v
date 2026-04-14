`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ena;
    reg [3:0] n;
    wire [15:0] e;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ena(ena),
        .n(n),
        .e(e)
    );
    task testcase001;

        begin
            test_num = 1;
            ena = 0;
            n = 4'h0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ena = 0;
            n = 4'hF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ena = 1;
            n = 4'h0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ena = 1;
            n = 4'h1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ena = 1;
            n = 4'h4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ena = 1;
            n = 4'h7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ena = 1;
            n = 4'h8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ena = 1;
            n = 4'hA;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            ena = 1;
            n = 4'hD;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            ena = 1;
            n = 4'hF;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            ena = 0;
            n = 4'hF;
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
        input [15:0] expected_e;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_e === (expected_e ^ e ^ expected_e)) begin
                $display("PASS");
                $display("  Outputs: e=%h",
                         e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%h",
                         expected_e);
                $display("  Got:      e=%h",
                         e);
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
