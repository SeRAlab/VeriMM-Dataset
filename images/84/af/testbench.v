`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] HRDATA;
    reg clk;
    reg reset;
    wire [3:0] op;
    wire [3:0] r1;
    wire [3:0] r2;
    wire [3:0] r3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HRDATA(HRDATA),
        .clk(clk),
        .reset(reset),
        .op(op),
        .r1(r1),
        .r2(r2),
        .r3(r3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'hABCD", test_num);
        reset = 1; clk = 0; HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'hABCD;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'hA, 4'hB, 4'hC, 4'hD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'h1234", test_num);
        reset = 1; clk = 0; HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'h1234;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'h1, 4'h2, 4'h3, 4'h4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'h0000", test_num);
        reset = 1; clk = 0; HRDATA = 16'hFFFF;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'hFFFF", test_num);
        reset = 1; clk = 0; HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'hFFFF;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'hF, 4'hF, 4'hF, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'h5A5A", test_num);
        reset = 1; clk = 0; HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'h5A5A;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'h5, 4'hA, 4'h5, 4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'hA5A5", test_num);
        reset = 1; clk = 0; HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'hA5A5;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'hA, 4'h5, 4'hA, 4'h5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'h7654", test_num);
        reset = 1; clk = 0; HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'h7654;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'h7, 4'h6, 4'h5, 4'h4);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: HRDATA = 16'h8001", test_num);
        reset = 1; clk = 0; HRDATA = 16'h0000;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        HRDATA = 16'h8001;
        #10 clk = 1; #10 clk = 0;
        #1;

        check_outputs(4'h8, 4'h0, 4'h0, 4'h1);
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
        input [3:0] expected_op;
        input [3:0] expected_r1;
        input [3:0] expected_r2;
        input [3:0] expected_r3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op) &&
                expected_r1 === (expected_r1 ^ r1 ^ expected_r1) &&
                expected_r2 === (expected_r2 ^ r2 ^ expected_r2) &&
                expected_r3 === (expected_r3 ^ r3 ^ expected_r3)) begin
                $display("PASS");
                $display("  Outputs: op=%h, r1=%h, r2=%h, r3=%h",
                         op, r1, r2, r3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h, r1=%h, r2=%h, r3=%h",
                         expected_op, expected_r1, expected_r2, expected_r3);
                $display("  Got:      op=%h, r1=%h, r2=%h, r3=%h",
                         op, r1, r2, r3);
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
