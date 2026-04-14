`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] g;
    wire [5:0] xor_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .xor_result(xor_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: g = 6'h00", test_num);
        g = 6'h00;
        #1;

        check_outputs(6'h1F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: g = 6'h1F", test_num);
        g = 6'h1F;
        #1;

        check_outputs(6'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: g = 6'h20", test_num);
        g = 6'h20;
        #1;

        check_outputs(6'h3F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: g = 6'h3F", test_num);
        g = 6'h3F;
        #1;

        check_outputs(6'h20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: g = 6'h15", test_num);
        g = 6'h15;
        #1;

        check_outputs(6'h0A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: g = 6'h2A", test_num);
        g = 6'h2A;
        #1;

        check_outputs(6'h35);
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
        input [5:0] expected_xor_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_xor_result === (expected_xor_result ^ xor_result ^ expected_xor_result)) begin
                $display("PASS");
                $display("  Outputs: xor_result=%h",
                         xor_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xor_result=%h",
                         expected_xor_result);
                $display("  Got:      xor_result=%h",
                         xor_result);
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
