`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Iset;
    reg V;
    reg enable;
    wire [31:0] I;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Iset(Iset),
        .V(V),
        .enable(enable),
        .I(I)
    );
    task testcase001;

    begin
        test_num = 1;
        Iset = 32'sd500;
        V = 1'b0;
        enable = 1'b0;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Iset = 32'sd1000;
        V = 1'b1;
        enable = 1'b1;
        #1;

        check_outputs(32'sd1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Iset = -32'sd2500;
        V = 1'b0;
        enable = 1'b1;
        #1;

        check_outputs(32'sd2500);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Iset = 32'sd0;
        V = 1'b1;
        enable = 1'b1;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Iset = -32'sd9999;
        V = 1'b1;
        enable = 1'b0;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Iset = 32'sh7FFFFFFF;
        V = 1'b0;
        enable = 1'b1;
        #1;

        check_outputs(32'sh7FFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Iset = -32'sd1;
        V = 1'b1;
        enable = 1'b1;
        #1;

        check_outputs(32'sd1);
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
        input [31:0] expected_I;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I === (expected_I ^ I ^ expected_I)) begin
                $display("PASS");
                $display("  Outputs: I=%h",
                         I);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%h",
                         expected_I);
                $display("  Got:      I=%h",
                         I);
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
