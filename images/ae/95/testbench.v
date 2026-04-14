`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg [1:0] op;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .op(op),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        op = 2'b00;
        data = 8'h43;
        $display("Test %0d: Addition 4 + 3", test_num);
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op = 2'b00;
        data = 8'hFF;
        $display("Test %0d: Addition 15 + 15", test_num);
        #1;

        check_outputs(8'h1E);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op = 2'b01;
        data = 8'hA4;
        $display("Test %0d: Subtraction 10 - 4", test_num);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op = 2'b01;
        data = 8'h55;
        $display("Test %0d: Subtraction 5 - 5", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op = 2'b10;
        data = 8'h34;
        $display("Test %0d: Multiplication 3 * 4", test_num);
        #1;

        check_outputs(8'h0C);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op = 2'b10;
        data = 8'hFA;
        $display("Test %0d: Multiplication 15 * 10", test_num);
        #1;

        check_outputs(8'h96);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op = 2'b11;
        data = 8'hC3;
        $display("Test %0d: Division 12 / 3", test_num);
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        op = 2'b11;
        data = 8'hF4;
        $display("Test %0d: Division 15 / 4", test_num);
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        op = 2'b10;
        data = 8'h0F;
        $display("Test %0d: Multiplication 0 * 15", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        op = 2'b01;
        data = 8'h25;
        $display("Test %0d: Subtraction 2 - 5", test_num);
        #1;

        check_outputs(8'hFD);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
