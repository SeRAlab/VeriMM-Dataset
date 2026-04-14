`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] led_data_in;
    reg [31:0] led_mask_in;
    reg rst;
    wire led_data_changed;
    wire led_data_masked;
    wire [31:0] led_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .led_data_in(led_data_in),
        .led_mask_in(led_mask_in),
        .rst(rst),
        .led_data_changed(led_data_changed),
        .led_data_masked(led_data_masked),
        .led_data_out(led_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        led_data_in = 0;
        led_mask_in = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset Verification", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0, 1'b0, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Direct Update (No Mask)", test_num);
        reset_dut();
        led_data_in = 32'hDEADBEEF;
        led_mask_in = 32'h00000000;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 1'b0, 32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Masked Update (Full Mask)", test_num);
        reset_dut();
        led_data_in = 32'hAAAA5555;
        led_mask_in = 32'hFFFFFFFF;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 1'b1, 32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Partial Masked Update", test_num);
        reset_dut();

        led_data_in = 32'hF0F0F0F0;
        led_mask_in = 32'h0;
        @(posedge clk);
        #1;

        led_data_in = 32'hFFFFFFFF;
        led_mask_in = 32'h0000FFFF;
        @(posedge clk);

        #1 #1;
 check_outputs(1'b0, 1'b1, 32'hF0F0FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: No Change Condition", test_num);
        reset_dut();

        led_data_in = 32'h12345678;
        led_mask_in = 0;
        @(posedge clk);
        #1;

        led_data_in = 32'h12345678;
        led_mask_in = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 1'b0, 32'h12345678);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Mask Priority", test_num);
        reset_dut();
        led_data_in = 32'hFFFFFFFF;
        led_mask_in = 32'h00000001;
        @(posedge clk);


        #1 #1;
 check_outputs(1'b0, 1'b1, 32'h00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Sequential Masked Updates", test_num);
        reset_dut();

        led_data_in = 32'h000000AA;
        led_mask_in = 32'h000000FF;
        @(posedge clk);
        #1;

        led_data_in = 32'h0000BB00;
        led_mask_in = 32'h0000FF00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 1'b1, 32'h0000BBAA);
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
        input expected_led_data_changed;
        input expected_led_data_masked;
        input [31:0] expected_led_data_out;
        begin
            if (expected_led_data_changed === (expected_led_data_changed ^ led_data_changed ^ expected_led_data_changed) &&
                expected_led_data_masked === (expected_led_data_masked ^ led_data_masked ^ expected_led_data_masked) &&
                expected_led_data_out === (expected_led_data_out ^ led_data_out ^ expected_led_data_out)) begin
                $display("PASS");
                $display("  Outputs: led_data_changed=%b, led_data_masked=%b, led_data_out=%h",
                         led_data_changed, led_data_masked, led_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_data_changed=%b, led_data_masked=%b, led_data_out=%h",
                         expected_led_data_changed, expected_led_data_masked, expected_led_data_out);
                $display("  Got:      led_data_changed=%b, led_data_masked=%b, led_data_out=%h",
                         led_data_changed, led_data_masked, led_data_out);
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
        $dumpvars(0,clk, led_data_in, led_mask_in, rst, led_data_changed, led_data_masked, led_data_out);
    end

endmodule
