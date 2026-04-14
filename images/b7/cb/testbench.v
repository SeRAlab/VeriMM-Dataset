`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ctrl;
    wire [1:0] en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .en(en)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: All control signals low");
            ctrl = 4'b0000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: en[0] logic - Only ctrl[0] high");
            ctrl = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: en[0] logic - Only ctrl[1] high");
            ctrl = 4'b0010;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: en[0] logic - Both ctrl[0] and ctrl[1] high");
            ctrl = 4'b0011;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: en[1] logic - Only ctrl[2] high");
            ctrl = 4'b0100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: en[1] logic - Only ctrl[3] high");
            ctrl = 4'b1000;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: en[1] logic - Both ctrl[2] and ctrl[3] high");
            ctrl = 4'b1100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Both en[0] and en[1] active");
            ctrl = 4'b1111;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Mixed condition - en[1] active, partial en[0]");
            ctrl = 4'b0101;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase 010: Mixed condition - en[0] active, partial en[1] (none)");
            ctrl = 4'b0011;
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en === (expected_en ^ en ^ expected_en)) begin
                $display("PASS");
                $display("  Outputs: en=%h",
                         en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%h",
                         expected_en);
                $display("  Got:      en=%h",
                         en);
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
