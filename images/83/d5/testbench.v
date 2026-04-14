`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in_value;
    reg [15:0] mask_value;
    reg [2:0] op_select;
    reg [3:0] shift_value;
    wire [15:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_value(in_value),
        .mask_value(mask_value),
        .op_select(op_select),
        .shift_value(shift_value),
        .out_value(out_value)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: AND operation (op=0)", test_num);
        in_value = 16'hAAAA;
        mask_value = 16'hF0F0;
        op_select = 3'd0;
        shift_value = 4'd0;
        #1;

        check_outputs(16'hA0A0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: OR operation (op=1)", test_num);
        in_value = 16'h1234;
        mask_value = 16'hF00F;
        op_select = 3'd1;
        shift_value = 4'd0;
        #1;

        check_outputs(16'hF23F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XOR operation (op=2)", test_num);
        in_value = 16'h5555;
        mask_value = 16'hFFFF;
        op_select = 3'd2;
        shift_value = 4'd0;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left Shift by 4 (op=3)", test_num);
        in_value = 16'h000F;
        mask_value = 16'h0000;
        op_select = 3'd3;
        shift_value = 4'd4;
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right Shift by 8 (op=4)", test_num);
        in_value = 16'hFF00;
        mask_value = 16'h0000;
        op_select = 3'd4;
        shift_value = 4'd8;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Default Behavior - Invalid Op (op=5)", test_num);
        in_value = 16'hBEEF;
        mask_value = 16'h1234;
        op_select = 3'd5;
        shift_value = 4'd4;
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Default Behavior - Invalid Op (op=7)", test_num);
        in_value = 16'hCAFE;
        mask_value = 16'h0000;
        op_select = 3'd7;
        shift_value = 4'd0;
        #1;

        check_outputs(16'hCAFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left Shift by 15 (op=3)", test_num);
        in_value = 16'h0001;
        mask_value = 16'h0000;
        op_select = 3'd3;
        shift_value = 4'd15;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right Shift resulting in zero (op=4)", test_num);
        in_value = 16'h000F;
        mask_value = 16'h0000;
        op_select = 3'd4;
        shift_value = 4'd4;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: AND with all 1s mask (op=0)", test_num);
        in_value = 16'h1357;
        mask_value = 16'hFFFF;
        op_select = 3'd0;
        shift_value = 4'd0;
        #1;

        check_outputs(16'h1357);
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
        input [15:0] expected_out_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: out_value=%h",
                         out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_value=%h",
                         expected_out_value);
                $display("  Got:      out_value=%h",
                         out_value);
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
