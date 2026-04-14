`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ena;
    reg [4:0] n;
    wire [31:0] e;

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
            test_num = test_num + 1;
            $display("Test %0d: Disabled State (ena=0, n=0)", test_num);
            ena = 0;
            n = 5'd0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable bit 0 (ena=1, n=0)", test_num);
            ena = 1;
            n = 5'd0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable bit 1 (ena=1, n=1)", test_num);
            ena = 1;
            n = 5'd1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable bit 4 (ena=1, n=4)", test_num);
            ena = 1;
            n = 5'd4;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable bit 15 (ena=1, n=15)", test_num);
            ena = 1;
            n = 5'd15;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable bit 16 (ena=1, n=16)", test_num);
            ena = 1;
            n = 5'd16;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable bit 31 (ena=1, n=31)", test_num);
            ena = 1;
            n = 5'd31;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Disabled State with high n (ena=0, n=31)", test_num);
            ena = 0;
            n = 5'd31;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable bit 10 (ena=1, n=10)", test_num);
            ena = 1;
            n = 5'd10;
            #1;

            check_outputs(32'h00000400);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Toggle Enable (ena=0, n=10)", test_num);
            ena = 0;
            n = 5'd10;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_e;
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
