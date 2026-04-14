`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] clk;
    reg [1:0] ctrl;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .out_clk(out_clk)
    );
    task testcase001;

    begin
        $display("Testcase 001: Select clk[0] - Level HIGH");
        test_num = 1;
        clk = 4'b0001;
        ctrl = 2'd0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Select clk[0] - Level LOW (while others are HIGH)");
        test_num = 2;
        clk = 4'b1110;
        ctrl = 2'd0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Select clk[1] - Level HIGH");
        test_num = 3;
        clk = 4'b0010;
        ctrl = 2'd1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Select clk[1] - Level LOW (while others are HIGH)");
        test_num = 4;
        clk = 4'b1101;
        ctrl = 2'd1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Select clk[2] - Level HIGH");
        test_num = 5;
        clk = 4'b0100;
        ctrl = 2'd2;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Select clk[2] - Level LOW (while others are HIGH)");
        test_num = 6;
        clk = 4'b1011;
        ctrl = 2'd2;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Select clk[3] - Level HIGH");
        test_num = 7;
        clk = 4'b1000;
        ctrl = 2'd3;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Select clk[3] - Level LOW (while others are HIGH)");
        test_num = 8;
        clk = 4'b0111;
        ctrl = 2'd3;
        #10;
        #1;

        check_outputs(1'b0);
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
        input expected_out_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b",
                         out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b",
                         expected_out_clk);
                $display("  Got:      out_clk=%b",
                         out_clk);
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
