`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] sample;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .rst(rst),
        .sample(sample),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        sample = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        reset_dut();
        sample = 4'd0; @(posedge clk); #1;
        sample = 4'd0; @(posedge clk); #1;
        sample = 4'd0; @(posedge clk); #1;
        sample = 4'd0; @(posedge clk); #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Unit Impulse (h3)", test_num);
        reset_dut();
        sample = 4'd1; @(posedge clk); #1;
        sample = 4'd0; @(posedge clk); #1;
        sample = 4'd0; @(posedge clk); #1;
        sample = 4'd0; @(posedge clk); #1;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: DC Input 1", test_num);
        reset_dut();
        sample = 4'd1; @(posedge clk); #1;
        sample = 4'd1; @(posedge clk); #1;
        sample = 4'd1; @(posedge clk); #1;
        sample = 4'd1; @(posedge clk); #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Value Input", test_num);
        reset_dut();
        sample = 4'd15; @(posedge clk); #1;
        sample = 4'd15; @(posedge clk); #1;
        sample = 4'd15; @(posedge clk); #1;
        sample = 4'd15; @(posedge clk); #1;
        #1;

        check_outputs(8'd150);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Ramp Input", test_num);
        reset_dut();
        sample = 4'd1; @(posedge clk); #1;
        sample = 4'd2; @(posedge clk); #1;
        sample = 4'd3; @(posedge clk); #1;
        sample = 4'd4; @(posedge clk); #1;
        #1;

        check_outputs(8'd20);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [7:0] expected_result;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, rst, sample, result);
    end

endmodule
