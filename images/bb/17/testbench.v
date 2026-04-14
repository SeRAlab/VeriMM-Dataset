`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg EN_update;
    reg RST_N;
    reg [15:0] update_x;
    reg [15:0] update_y;
    wire RDY_update;
    wire [15:0] update;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN_update(EN_update),
        .RST_N(RST_N),
        .update_x(update_x),
        .update_y(update_y),
        .RDY_update(RDY_update),
        .update(update)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase001: Basic arithmetic...");
        reset_dut();
        update_x = 16'd10;
        update_y = 16'd20;
        EN_update = 1;
        @(posedge CLK);
        #1;

        check_outputs(1'b1, 16'd60);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase002: Zero inputs...");
        reset_dut();
        update_x = 16'd0;
        update_y = 16'd0;
        EN_update = 1;
        @(posedge CLK);
        #1;

        check_outputs(1'b1, 16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase003: Addition overflow (16-bit)...");
        reset_dut();
        update_x = 16'hFFFF;
        update_y = 16'h0001;
        EN_update = 1;
        @(posedge CLK);
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase004: Multiplication overflow (16-bit)...");
        reset_dut();
        update_x = 16'h4000;
        update_y = 16'h4000;
        EN_update = 1;
        @(posedge CLK);
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase005: Moderate values...");
        reset_dut();
        update_x = 16'd1000;
        update_y = 16'd2000;
        EN_update = 1;
        @(posedge CLK);
        #1;

        check_outputs(1'b1, 16'd6000);
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
        input expected_RDY_update;
        input [15:0] expected_update;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RDY_update === (expected_RDY_update ^ RDY_update ^ expected_RDY_update) &&
                expected_update === (expected_update ^ update ^ expected_update)) begin
                $display("PASS");
                $display("  Outputs: RDY_update=%b, update=%h",
                         RDY_update, update);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDY_update=%b, update=%h",
                         expected_RDY_update, expected_update);
                $display("  Got:      RDY_update=%b, update=%h",
                         RDY_update, update);
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
