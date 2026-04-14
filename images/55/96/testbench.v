`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] EU_immediate;
    reg ExtSign;
    wire [31:0] extended;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EU_immediate(EU_immediate),
        .ExtSign(ExtSign),
        .extended(extended)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sign-extend positive value (MSB=0, ExtSign=1)", test_num);
        EU_immediate = 16'h0001;
        ExtSign = 1'b1;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sign-extend negative value (MSB=1, ExtSign=1)", test_num);
        EU_immediate = 16'h8000;
        ExtSign = 1'b1;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sign-extend maximum positive value (ExtSign=1)", test_num);
        EU_immediate = 16'h7FFF;
        ExtSign = 1'b1;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sign-extend all ones (ExtSign=1)", test_num);
        EU_immediate = 16'hFFFF;
        ExtSign = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero-extend positive value (ExtSign=0)", test_num);
        EU_immediate = 16'h1234;
        ExtSign = 1'b0;

        #1;


        check_outputs(32'h00001234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero-extend value with MSB=1 (ExtSign=0)", test_num);
        EU_immediate = 16'h8001;
        ExtSign = 1'b0;
        #1;

        check_outputs(32'h00008001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero input (ExtSign=1)", test_num);
        EU_immediate = 16'h0000;
        ExtSign = 1'b1;
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
        input [31:0] expected_extended;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extended === (expected_extended ^ extended ^ expected_extended)) begin
                $display("PASS");
                $display("  Outputs: extended=%h",
                         extended);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extended=%h",
                         expected_extended);
                $display("  Got:      extended=%h",
                         extended);
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
