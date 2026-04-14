`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg [3:0] match;
    wire [7:0] data_out;
    wire match_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .match(match),
        .data_out(data_out),
        .match_out(match_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Perfect match on lower nibble");
        data = 8'hA5;
        match = 4'h5;

        #1;


        check_outputs(8'hA5, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Complete mismatch");
        data = 8'hA5;
        match = 4'hA;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: All bits set match");
        data = 8'hFF;
        match = 4'hF;
        #1;

        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: All zeros match");
        data = 8'h00;
        match = 4'h0;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Different upper bits, matching lower nibble");
        data = 8'h15;
        match = 4'h5;
        #1;

        check_outputs(8'h15, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Different upper bits (0x20), matching lower nibble");
        data = 8'h25;
        match = 4'h5;
        #1;

        check_outputs(8'h25, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Mismatch by single bit (0x4 vs 0x5)");
        data = 8'h54;
        match = 4'h5;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Boundary pattern match");
        data = 8'h3F;
        match = 4'hF;
        #1;

        check_outputs(8'h3F, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_match_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_match_out === (expected_match_out ^ match_out ^ expected_match_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, match_out=%b",
                         data_out, match_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, match_out=%b",
                         expected_data_out, expected_match_out);
                $display("  Got:      data_out=%h, match_out=%b",
                         data_out, match_out);
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
