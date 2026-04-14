`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] out_conv;
    wire [31:0] out_relu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .out_conv(out_conv),
        .out_relu(out_relu)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero input", test_num);
        out_conv = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Small positive value", test_num);
        out_conv = 32'h0000_0005;
        #1;

        check_outputs(32'h0000_0005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Maximum positive value", test_num);
        out_conv = 32'h7FFF_FFFF;
        #1;

        check_outputs(32'h7FFF_FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Small negative value (-1)", test_num);
        out_conv = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Maximum negative value", test_num);
        out_conv = 32'h8000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Random positive bit pattern", test_num);
        out_conv = 32'h1234_5678;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Random negative bit pattern", test_num);
        out_conv = 32'hABCD_EF01;
        #1;

        check_outputs(32'h0000_0000);
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
        input [31:0] expected_out_relu;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_relu === (expected_out_relu ^ out_relu ^ expected_out_relu)) begin
                $display("PASS");
                $display("  Outputs: out_relu=%h",
                         out_relu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_relu=%h",
                         expected_out_relu);
                $display("  Got:      out_relu=%h",
                         out_relu);
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
