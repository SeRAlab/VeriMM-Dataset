`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [4:0] select;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        $display("Testcase 001: Enable high, select index 0");
        enable = 1'b1;
        select = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Enable high, select index 1");
        enable = 1'b1;
        select = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Enable high, select index 4");
        enable = 1'b1;
        select = 5'd4;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Enable high, select index 8");
        enable = 1'b1;
        select = 5'd8;
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Enable high, select index 15");
        enable = 1'b1;
        select = 5'd15;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Enable high, select index 16");
        enable = 1'b1;
        select = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Enable high, select index 24");
        enable = 1'b1;
        select = 5'd24;
        #1;

        check_outputs(32'h01000000);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Enable high, select index 31");
        enable = 1'b1;
        select = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Enable low, select index 0 (Output should be all 0)");
        enable = 1'b0;
        select = 5'd0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Enable low, select index 31 (Output should be all 0)");
        enable = 1'b0;
        select = 5'd31;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase011;

    begin
        $display("Testcase 011: Enable low, select index 15 (Output should be all 0)");
        enable = 1'b0;
        select = 5'd15;
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
