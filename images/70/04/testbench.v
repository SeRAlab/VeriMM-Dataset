`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg invert;
    wire [15:0] data_out;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .invert(invert),
        .data_out(data_out),
        .match(match)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Match without inversion", test_num);
        data_in = 32'hAABB1234;
        invert = 1'b0;
        #1;

        check_outputs(16'h1234, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Match with inversion", test_num);
        data_in = 32'h0000EDCB;
        invert = 1'b1;
        #1;

        check_outputs(16'h1234, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: No match without inversion", test_num);
        data_in = 32'hFFFF0000;
        invert = 1'b0;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: No match with inversion", test_num);
        data_in = 32'hFFFFFFFF;
        invert = 1'b1;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Verify MSB 16-bits are ignored", test_num);
        data_in = 32'hDEAD1234;
        invert = 1'b0;
        #1;

        check_outputs(16'h1234, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: General pattern check", test_num);
        data_in = 32'h000055AA;
        invert = 1'b0;
        #1;

        check_outputs(16'h55AA, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: General pattern check with inversion", test_num);
        data_in = 32'h000055AA;
        invert = 1'b1;
        #1;

        check_outputs(16'hAA55, 1'b0);
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
        input [15:0] expected_data_out;
        input expected_match;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, match=%b",
                         data_out, match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, match=%b",
                         expected_data_out, expected_match);
                $display("  Got:      data_out=%h, match=%b",
                         data_out, match);
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
