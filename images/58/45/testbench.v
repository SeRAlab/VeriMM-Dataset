`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] extend_in;
    wire [31:0] extend_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .extend_in(extend_in),
        .extend_out(extend_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero input", test_num);
        extend_in = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max positive (MSB=0)", test_num);
        extend_in = 16'h7FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min negative (MSB=1)", test_num);
        extend_in = 16'h8000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones (-1)", test_num);
        extend_in = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary positive", test_num);
        extend_in = 16'h1234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary negative", test_num);
        extend_in = 16'hABCD;
        #1;

        check_outputs(32'hFFFFABCD);
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
        input [31:0] expected_extend_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extend_out === (expected_extend_out ^ extend_out ^ expected_extend_out)) begin
                $display("PASS");
                $display("  Outputs: extend_out=%h",
                         extend_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extend_out=%h",
                         expected_extend_out);
                $display("  Got:      extend_out=%h",
                         extend_out);
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
