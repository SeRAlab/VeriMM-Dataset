`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    reg [7:0] z;
    wire [7:0] w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .z(z),
        .w(w)
    );
    task testcase001;

    begin
        $display("Test Case 001: All Zeros");
        x = 8'h00;
        z = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: All Ones");
        x = 8'hFF;
        z = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Bitwise complement inputs (AA & 55)");
        x = 8'hAA;
        z = 8'h55;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Identity (Value & FF)");
        x = 8'hA5;
        z = 8'hFF;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Zero masking (Value & 00)");
        x = 8'h3C;
        z = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Nibble masking (F0 & CC)");
        x = 8'hF0;
        z = 8'hCC;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Interleaved bits");
        x = 8'b11011011;
        z = 8'b10110110;
        #1;

        check_outputs(8'b10010010);
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
        input [7:0] expected_w;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: w=%h",
                         w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h",
                         expected_w);
                $display("  Got:      w=%h",
                         w);
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
