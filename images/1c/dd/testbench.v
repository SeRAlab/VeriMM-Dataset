`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] x;
    wire [1:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        x = 0;
        @(posedge clk);
        #1 rst = 0;

        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic single addition", test_num);
        reset_dut();
        x = 2'd1;
        @(posedge clk);
        #1 #1;
 check_outputs(2'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sequence accumulation", test_num);
        reset_dut();
        x = 2'd1; @(posedge clk);
        #1 x = 2'd2; @(posedge clk);
        #1 #1;
 check_outputs(2'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Modulo 4 wrap-around (even)", test_num);
        reset_dut();
        x = 2'd2; @(posedge clk);
        #1 x = 2'd2; @(posedge clk);
        #1 #1;
 check_outputs(2'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Modulo 4 wrap-around with remainder", test_num);
        reset_dut();
        x = 2'd3; @(posedge clk);
        #1 x = 2'd2; @(posedge clk);
        #1 #1;
 check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Input zero maintains state", test_num);
        reset_dut();
        x = 2'd2; @(posedge clk);
        #1 x = 2'd0; @(posedge clk);
        #1 #1;
 check_outputs(2'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Large sequence overflow", test_num);
        reset_dut();
        x = 2'd3; @(posedge clk);
        #1 x = 2'd3; @(posedge clk);
        #1 x = 2'd3; @(posedge clk);
        #1 #1;
 check_outputs(2'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify reset clears state", test_num);
        reset_dut();
        x = 2'd2; @(posedge clk);
        #1 rst = 1; @(posedge clk);
        #1 rst = 0; x = 2'd1; @(posedge clk);
        #1 #1;
 check_outputs(2'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [1:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, rst, x, y);
    end

endmodule
