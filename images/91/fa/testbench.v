`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] wa;
    reg [7:0] wb;
    wire [7:0] result;
    wire [7:0] wresult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .wa(wa),
        .wb(wb),
        .result(result),
        .wresult(wresult)
    );
    task testcase001;

    begin
        $display("Testcase 001: Normal Division");
        a = 8'd20; b = 8'd5;
        wa = 8'd100; wb = 8'd10;
        #1;

        check_outputs(8'd4, 8'd10);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Division by zero (b=0)");
        a = 8'd10; b = 8'd0;
        wa = 8'd20; wb = 8'd2;
        #1;

        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Division by zero (wb=0)");
        a = 8'd15; b = 8'd3;
        wa = 8'd50; wb = 8'd0;
        #1;

        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Special Rule (a=0, b=10)");
        a = 8'd0; b = 8'd10;
        wa = 8'd40; wb = 8'd4;
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Both operands a and b are zero");
        a = 8'd0; b = 8'd0;
        wa = 8'd10; wb = 8'd2;
        #1;

        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: wa=0, wb=5 (Normal division result)");
        a = 8'd10; b = 8'd2;
        wa = 8'd0; wb = 8'd5;
        #1;

        check_outputs(8'd5, 8'd0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Large values and integer floor check");
        a = 8'd255; b = 8'd2;
        wa = 8'd255; wb = 8'd255;
        #1;

        check_outputs(8'd127, 8'd1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Priority check (a=10, b=0)");
        a = 8'd10; b = 8'd0;
        wa = 8'd10; wb = 8'd10;
        #1;

        check_outputs(8'd0, 8'd0);
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
        input [7:0] expected_result;
        input [7:0] expected_wresult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_wresult === (expected_wresult ^ wresult ^ expected_wresult)) begin
                $display("PASS");
                $display("  Outputs: result=%h, wresult=%h",
                         result, wresult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, wresult=%h",
                         expected_result, expected_wresult);
                $display("  Got:      result=%h, wresult=%h",
                         result, wresult);
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
