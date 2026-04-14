`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] KEY;
    reg clk;
    reg resetn;
    wire [3:0] key_held;
    wire [3:0] key_pressed;
    wire [3:0] key_released;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .KEY(KEY),
        .clk(clk),
        .resetn(resetn),
        .key_held(key_held),
        .key_pressed(key_pressed),
        .key_released(key_released)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        KEY = 4'b0000;

        repeat(2) @(posedge clk);
        #1 resetn = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Key Press Detection", test_num);
        reset_dut();
        KEY = 4'b0001;
        @(posedge clk);
        #2 #1;
 check_outputs(4'h1, 4'h1, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Key Held Detection", test_num);
        reset_dut();
        KEY = 4'b0010;
        @(posedge clk);
        @(posedge clk);
        #2 #1;
 check_outputs(4'h2, 4'h0, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Key Release Detection", test_num);
        reset_dut();
        KEY = 4'b0100;
        @(posedge clk);
        KEY = 4'b0000;
        @(posedge clk);
        #2 #1;
 check_outputs(4'h0, 4'h0, 4'h4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simultaneous Multi-Key Press", test_num);
        reset_dut();
        KEY = 4'b1011;
        @(posedge clk);
        #2 #1;
 check_outputs(4'hB, 4'hB, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Interleaved Key Transitions", test_num);
        reset_dut();
        KEY = 4'b0011;
        @(posedge clk);
        KEY = 4'b0001;
        @(posedge clk);
        #2 #1;
 check_outputs(4'h1, 4'h0, 4'h2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overlapping Key Press", test_num);
        reset_dut();
        KEY = 4'b0001;
        @(posedge clk);
        KEY = 4'b1001;
        @(posedge clk);
        #2 #1;
 check_outputs(4'h9, 4'h8, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single-Cycle Pulse Detection", test_num);
        reset_dut();
        KEY = 4'b1000;
        @(posedge clk);
        KEY = 4'b0000;
        @(posedge clk);
        #2 #1;
 check_outputs(4'h0, 4'h0, 4'h8);
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
        input [3:0] expected_key_held;
        input [3:0] expected_key_pressed;
        input [3:0] expected_key_released;
        begin
            if (expected_key_held === (expected_key_held ^ key_held ^ expected_key_held) &&
                expected_key_pressed === (expected_key_pressed ^ key_pressed ^ expected_key_pressed) &&
                expected_key_released === (expected_key_released ^ key_released ^ expected_key_released)) begin
                $display("PASS");
                $display("  Outputs: key_held=%h, key_pressed=%h, key_released=%h",
                         key_held, key_pressed, key_released);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key_held=%h, key_pressed=%h, key_released=%h",
                         expected_key_held, expected_key_pressed, expected_key_released);
                $display("  Got:      key_held=%h, key_pressed=%h, key_released=%h",
                         key_held, key_pressed, key_released);
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
        $dumpvars(0,KEY, clk, resetn, key_held, key_pressed, key_released);
    end

endmodule
