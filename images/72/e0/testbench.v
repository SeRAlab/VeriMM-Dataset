`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ABC;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABC(ABC),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: ABC = 0 (3'b000)");
            ABC = 3'b000;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: ABC = 1 (3'b001)");
            ABC = 3'b001;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: ABC = 2 (3'b010)");
            ABC = 3'b010;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: ABC = 3 (3'b011)");
            ABC = 3'b011;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: ABC = 4 (3'b100)");
            ABC = 3'b100;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: ABC = 5 (3'b101)");
            ABC = 3'b101;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: ABC = 6 (3'b110)");
            ABC = 3'b110;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: ABC = 7 (3'b111)");
            ABC = 3'b111;
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
