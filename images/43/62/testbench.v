`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inst;
    wire [31:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inst(inst),
        .d_out(d_out)
    );
    task testcase001;

    begin
        test_num = 1;
        inst = 32'h00A00093;
        #1;

        check_outputs(32'h0000000A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        inst = 32'hFFF00093;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        inst = 32'h0062AA23;
        #1;

        check_outputs(32'h00000014);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        inst = 32'hFE62A623;
        #1;

        check_outputs(32'hFFFFFFEC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        inst = 32'h7FF00093;
        #1;

        check_outputs(32'h000007FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        inst = 32'h80000093;
        #1;

        check_outputs(32'hFFFFF800);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        inst = 32'h02852283;
        #1;

        check_outputs(32'h00000028);
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
        input [31:0] expected_d_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
