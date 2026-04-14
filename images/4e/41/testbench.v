`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] Valor_Decimal;
    wire [7:0] Code_7seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Valor_Decimal(Valor_Decimal),
        .Code_7seg(Code_7seg)
    );
    task testcase001;

    begin
        $display("\nTestcase 001: Input 0");
        Valor_Decimal = 4'd0;
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Input 1");
        Valor_Decimal = 4'd1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Input 2");
        Valor_Decimal = 4'd2;
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Input 3");
        Valor_Decimal = 4'd3;
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Input 4");
        Valor_Decimal = 4'd4;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Input 5");
        Valor_Decimal = 4'd5;
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        $display("\nTestcase 007: Input 6");
        Valor_Decimal = 4'd6;
        #1;

        check_outputs(8'h7D);
    end
        endtask

    task testcase008;

    begin
        $display("\nTestcase 008: Input 7");
        Valor_Decimal = 4'd7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        $display("\nTestcase 009: Input 8");
        Valor_Decimal = 4'd8;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        $display("\nTestcase 010: Input 9");
        Valor_Decimal = 4'd9;
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        $display("\nTestcase 011: Invalid Input 10");
        Valor_Decimal = 4'd10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase012;

    begin
        $display("\nTestcase 012: Invalid Input 15");
        Valor_Decimal = 4'd15;
        #1;

        check_outputs(8'h00);
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
        testcase012();
        
        
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
        input [7:0] expected_Code_7seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Code_7seg === (expected_Code_7seg ^ Code_7seg ^ expected_Code_7seg)) begin
                $display("PASS");
                $display("  Outputs: Code_7seg=%h",
                         Code_7seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Code_7seg=%h",
                         expected_Code_7seg);
                $display("  Got:      Code_7seg=%h",
                         Code_7seg);
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
