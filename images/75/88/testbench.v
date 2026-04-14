`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d_i;
    reg [2:0] size_i;
    wire [31:0] q_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_i(d_i),
        .size_i(size_i),
        .q_o(q_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Full swap (size_i = 4)", test_num);
        d_i = 32'h12345678;
        size_i = 3'd4;

        #1;


        check_outputs(32'h78563412);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Half swap (size_i = 2)", test_num);
        d_i = 32'h12345678;
        size_i = 3'd2;

        #1;


        check_outputs(32'h12347856);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Partial swap (size_i = 3)", test_num);
        d_i = 32'h12345678;
        size_i = 3'd3;

        #1;


        check_outputs(32'h12785634);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Single byte swap (size_i = 1)", test_num);
        d_i = 32'hAABBCCDD;
        size_i = 3'd1;

        #1;


        check_outputs(32'hAABBCCDD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Zero byte swap (size_i = 0)", test_num);
        d_i = 32'hDEADBEEF;
        size_i = 3'd0;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Full swap with alternative data", test_num);
        d_i = 32'h00112233;
        size_i = 3'd4;

        #1;


        check_outputs(32'h33221100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Multi-byte swap with edge values", test_num);
        d_i = 32'hFFFF0000;
        size_i = 3'd2;

        #1;


        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Full swap with all-ones input", test_num);
        d_i = 32'hFFFFFFFF;
        size_i = 3'd4;
        #1;

        check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_q_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q_o === (expected_q_o ^ q_o ^ expected_q_o)) begin
                $display("PASS");
                $display("  Outputs: q_o=%h",
                         q_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_o=%h",
                         expected_q_o);
                $display("  Got:      q_o=%h",
                         q_o);
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
