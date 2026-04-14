`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in0;
    reg [3:0] in1;
    reg mode;
    reg reset;
    wire eq;
    wire [3:0] final_output;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .mode(mode),
        .reset(reset),
        .eq(eq),
        .final_output(final_output),
        .gt(gt),
        .lt(lt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        in0 = 0;
        in1 = 0;
        mode = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Addition 0 + 0", test_num);
        in0 = 4'd0;
        in1 = 4'd0;
        mode = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'b0000, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Addition 2 + 3", test_num);
        in0 = 4'd2;
        in1 = 4'd3;
        mode = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'd5, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction 7 - 7", test_num);
        in0 = 4'd7;
        in1 = 4'd7;
        mode = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'b0000, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction 2 - 5", test_num);
        in0 = 4'd2;
        in1 = 4'd5;
        mode = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'b1101, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Addition 7 + 1 (Signed Overflow)", test_num);
        in0 = 4'b0111;
        in1 = 4'b0001;
        mode = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'b1000, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction 6 - 2", test_num);
        in0 = 4'd6;
        in1 = 4'd2;
        mode = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'd4, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Reset Check", test_num);
        in0 = 4'd5;
        in1 = 4'd2;
        mode = 1'b0;
        @(posedge clk);
        #2 reset = 1;
        #1 #1;
 check_outputs(1'b0, 4'b0000, 1'b0, 1'b0);
        reset = 0;
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
        input expected_eq;
        input [3:0] expected_final_output;
        input expected_gt;
        input expected_lt;
        begin
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, final_output=%h, gt=%b, lt=%b",
                         eq, final_output, gt, lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, final_output=%h, gt=%b, lt=%b",
                         expected_eq, expected_final_output, expected_gt, expected_lt);
                $display("  Got:      eq=%b, final_output=%h, gt=%b, lt=%b",
                         eq, final_output, gt, lt);
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
        $dumpvars(0,clk, in0, in1, mode, reset, eq, final_output, gt, lt);
    end

endmodule
