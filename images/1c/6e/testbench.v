`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adc_data;
    reg clk;
    reg rst;
    reg [15:0] threshold;
    wire adc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_data(adc_data),
        .clk(clk),
        .rst(rst),
        .threshold(threshold),
        .adc_out(adc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        adc_data = 0;
        threshold = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Data greater than threshold (16'hA000 > 16'h5000)");
        reset_dut();
        adc_data = 16'hA000;
        threshold = 16'h5000;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Data less than threshold (16'h2000 < 16'h5000)");
        reset_dut();
        adc_data = 16'h2000;
        threshold = 16'h5000;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Data equal to threshold (16'h8000 == 16'h8000)");
        reset_dut();
        adc_data = 16'h8000;
        threshold = 16'h8000;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Data and threshold are both zero");
        reset_dut();
        adc_data = 16'h0000;
        threshold = 16'h0000;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Data and threshold are both max (16'hFFFF)");
        reset_dut();
        adc_data = 16'hFFFF;
        threshold = 16'hFFFF;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Data 0, Threshold 16'hFFFF");
        reset_dut();
        adc_data = 16'h0000;
        threshold = 16'hFFFF;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Data 16'hFFFF, Threshold 0");
        reset_dut();
        adc_data = 16'hFFFF;
        threshold = 16'h0000;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_controller Testbench");
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
        input expected_adc_out;
        begin
            if (expected_adc_out === (expected_adc_out ^ adc_out ^ expected_adc_out)) begin
                $display("PASS");
                $display("  Outputs: adc_out=%b",
                         adc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_out=%b",
                         expected_adc_out);
                $display("  Got:      adc_out=%b",
                         adc_out);
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
        $dumpvars(0,adc_data, clk, rst, threshold, adc_out);
    end

endmodule
