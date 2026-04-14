`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] BIN;
    wire [2:0] GRAY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BIN(BIN),
        .GRAY(GRAY)
    );
    task testcase001;

        begin
            BIN = 3'b000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            BIN = 3'b001;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            BIN = 3'b010;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            BIN = 3'b011;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            BIN = 3'b100;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase006;

        begin
            BIN = 3'b101;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            BIN = 3'b110;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase008;

        begin
            BIN = 3'b111;
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_GRAY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GRAY === (expected_GRAY ^ GRAY ^ expected_GRAY)) begin
                $display("PASS");
                $display("  Outputs: GRAY=%h",
                         GRAY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRAY=%h",
                         expected_GRAY);
                $display("  Got:      GRAY=%h",
                         GRAY);
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
