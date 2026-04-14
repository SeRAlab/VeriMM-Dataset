`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] color_in;
    reg [1:0] phase;
    reg [1:0] x;
    reg y;
    wire [1:0] color_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .color_in(color_in),
        .phase(phase),
        .x(x),
        .y(y),
        .color_out(color_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        color_in = 4'b1011;
        phase = 2'b00;
        x = 2'b00;
        y = 1'b0;
        #10;
        $display("Testcase %0d: Basic Selection (Origin)", test_num);

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        color_in = 4'b0111;
        phase = 2'b00;
        x = 2'b01;
        y = 1'b0;
        #10;
        $display("Testcase %0d: X-axis Shift", test_num);

        #1;


        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        color_in = 4'b0010;
        phase = 2'b00;
        x = 2'b00;
        y = 1'b1;
        #10;
        $display("Testcase %0d: Y-axis Shift", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        color_in = 4'b1100;
        phase = 2'b01;
        x = 2'b00;
        y = 1'b0;
        #10;
        $display("Testcase %0d: Phase Rotation", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        color_in = 4'b0110;
        phase = 2'b11;
        x = 2'b11;
        y = 1'b1;
        #10;
        $display("Testcase %0d: Combined Offset (Max Inputs)", test_num);

        #1;


        check_outputs(2'b01);
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
        input [1:0] expected_color_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_color_out === (expected_color_out ^ color_out ^ expected_color_out)) begin
                $display("PASS");
                $display("  Outputs: color_out=%h",
                         color_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_out=%h",
                         expected_color_out);
                $display("  Got:      color_out=%h",
                         color_out);
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
