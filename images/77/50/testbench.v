`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg check;
    reg [7:0] checksum_in;
    reg [7:0] data_in;
    wire [7:0] checksum_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .check(check),
        .checksum_in(checksum_in),
        .data_in(data_in),
        .checksum_out(checksum_out),
        .error(error)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All zeros, check disabled", test_num);
        data_in = 8'b0000_0000;
        check = 0;
        checksum_in = 8'h00;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All ones, check disabled (Sum=8, Mod=0)", test_num);
        data_in = 8'b1111_1111;
        check = 0;
        checksum_in = 8'h00;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Data with 3 bits set, check enabled - MATCH", test_num);
        data_in = 8'b1110_0000;
        check = 1;
        checksum_in = 8'h03;
        #1;

        check_outputs(8'h03, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Data with 3 bits set, check enabled - MISMATCH", test_num);
        data_in = 8'b1110_0000;
        check = 1;
        checksum_in = 8'h05;
        #1;

        check_outputs(8'h03, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating bits, check enabled - MATCH", test_num);
        data_in = 8'b1010_1010;
        check = 1;
        checksum_in = 8'h04;
        #1;

        check_outputs(8'h04, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Max remainder (7), check enabled - MATCH", test_num);
        data_in = 8'b0111_1111;
        check = 1;
        checksum_in = 8'h07;
        #1;

        check_outputs(8'h07, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Sum is 8 (Mod 0), check enabled - MISMATCH against sum value", test_num);
        data_in = 8'b1111_1111;
        check = 1;
        checksum_in = 8'h08;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Single bit, check enabled - MATCH", test_num);
        data_in = 8'b0000_1000;
        check = 1;
        checksum_in = 8'h01;
        #1;

        check_outputs(8'h01, 1'b0);
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
        input [7:0] expected_checksum_out;
        input expected_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, error=%b",
                         checksum_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, error=%b",
                         expected_checksum_out, expected_error);
                $display("  Got:      checksum_out=%h, error=%b",
                         checksum_out, error);
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
