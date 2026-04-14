`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire [9:0] actual_x;
    wire [8:0] actual_y;
    wire h_sync;
    wire v_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .actual_x(actual_x),
        .actual_y(actual_y),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clock);
        #2 reset = 0;

    end
    endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Post-Reset State", test_num);
        reset_dut();
        #2 #1;
 check_outputs(10'd0, 9'd0, 1'b1, 1'b1);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: End of visible horizontal region", test_num);
        reset_dut();
        repeat(639) @(posedge clock);
        #2 #1;
 check_outputs(10'd639, 9'd0, 1'b1, 1'b1);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Horizontal sync pulse activation", test_num);
        reset_dut();
        repeat(656) @(posedge clock);
        #2 #1;
 check_outputs(10'd656, 9'd0, 1'b0, 1'b1);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Horizontal wrap-around and line increment", test_num);
        reset_dut();
        repeat(800) @(posedge clock);
        #2 #1;
 check_outputs(10'd0, 9'd1, 1'b1, 1'b1);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Vertical sync pulse activation", test_num);
        reset_dut();

        repeat(490 * 800) @(posedge clock);
        #2 #1;
 check_outputs(10'd0, 9'd490, 1'b1, 1'b0);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous H-Sync and V-Sync", test_num);
        reset_dut();
        repeat(490 * 800 + 656) @(posedge clock);
        #2 #1;
 check_outputs(10'd656, 9'd490, 1'b0, 1'b0);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: End of horizontal sync pulse", test_num);
        reset_dut();
        repeat(751) @(posedge clock);
        #2 #1;
 check_outputs(10'd751, 9'd0, 1'b0, 1'b1);
        @(posedge clock);
        #2 #1;
 check_outputs(10'd752, 9'd0, 1'b1, 1'b1);
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
        input [9:0] expected_actual_x;
        input [8:0] expected_actual_y;
        input expected_h_sync;
        input expected_v_sync;
        begin
            if (expected_actual_x === (expected_actual_x ^ actual_x ^ expected_actual_x) &&
                expected_actual_y === (expected_actual_y ^ actual_y ^ expected_actual_y) &&
                expected_h_sync === (expected_h_sync ^ h_sync ^ expected_h_sync) &&
                expected_v_sync === (expected_v_sync ^ v_sync ^ expected_v_sync)) begin
                $display("PASS");
                $display("  Outputs: actual_x=%h, actual_y=%h, h_sync=%b, v_sync=%b",
                         actual_x, actual_y, h_sync, v_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: actual_x=%h, actual_y=%h, h_sync=%b, v_sync=%b",
                         expected_actual_x, expected_actual_y, expected_h_sync, expected_v_sync);
                $display("  Got:      actual_x=%h, actual_y=%h, h_sync=%b, v_sync=%b",
                         actual_x, actual_y, h_sync, v_sync);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, reset, actual_x, actual_y, h_sync, v_sync);
    end

endmodule
