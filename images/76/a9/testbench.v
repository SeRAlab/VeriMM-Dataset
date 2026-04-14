`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg [1:0] op;
    wire over;
    wire [2:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .over(over),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 3'd2; b = 3'd3; op = OP_SUM;
        #1;

        check_outputs(1'b0, 3'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 3'd5; b = 3'd4; op = OP_SUM;
        #1;

        check_outputs(1'b1, 3'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 3'd7; b = 3'd1; op = OP_SUM;
        #1;

        check_outputs(1'b1, 3'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 3'd5; b = 3'd2; op = OP_SUB;
        #1;

        check_outputs(1'b0, 3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 3'd2; b = 3'd5; op = OP_SUB;
        #1;

        check_outputs(1'b0, 3'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 3'd3; b = 3'd6; op = OP_MAX;
        #1;

        check_outputs(1'b0, 3'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 3'd7; b = 3'd2; op = OP_MAX;
        #1;

        check_outputs(1'b0, 3'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 3'd4; b = 3'd4; op = OP_MAX;
        #1;

        check_outputs(1'b0, 3'd4);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 3'd0; b = 3'd0; op = OP_SUM;
        #1;

        check_outputs(1'b0, 3'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 3'd7; b = 3'd7; op = OP_SUM;
        #1;

        check_outputs(1'b1, 3'd6);
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
        testcase009();
        testcase010();
        
        
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
        input expected_over;
        input [2:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_over === (expected_over ^ over ^ expected_over) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: over=%b, res=%h",
                         over, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: over=%b, res=%h",
                         expected_over, expected_res);
                $display("  Got:      over=%b, res=%h",
                         over, res);
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
