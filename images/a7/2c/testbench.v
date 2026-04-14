`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] mantissa;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mantissa(mantissa),
        .count(count)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All bits set (Expected count: 0)");
        mantissa = 10'b1111111111;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: MSB is one (Expected count: 0)");
        mantissa = 10'b1000000000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: One leading zero (Expected count: 1)");
        mantissa = 10'b0100000000;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Two leading zeros (Expected count: 2)");
        mantissa = 10'b0011110000;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Three leading zeros (Expected count: 3)");
        mantissa = 10'b0001010101;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Four leading zeros (Expected count: 4)");
        mantissa = 10'b0000100000;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Five leading zeros (Expected count: 5)");
        mantissa = 10'b0000011000;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Six leading zeros (Expected count: 6)");
        mantissa = 10'b0000001111;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: Seven leading zeros (Expected count: 7)");
        mantissa = 10'b0000000101;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: Eight leading zeros (Expected count: 8)");
        mantissa = 10'b0000000011;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase 011: Nine leading zeros (Expected count: 9)");
        mantissa = 10'b0000000001;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase 012: Ten leading zeros - All Zeros (Expected count: 10)");
        mantissa = 10'b0000000000;
        #1;

        check_outputs(4'd10);
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
        input [3:0] expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
