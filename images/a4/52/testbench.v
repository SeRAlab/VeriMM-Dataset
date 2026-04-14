`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg rst_n;
    reg sck;
    reg ssel;
    wire miso;
    wire recived_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mosi(mosi),
        .rst_n(rst_n),
        .sck(sck),
        .ssel(ssel),
        .miso(miso),
        .recived_status(recived_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        mosi = 0;
        sck = 0;
        ssel = 1;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Sending 8-bit 0xA5 (10100101)", test_num);
        reset_dut();
        send_bits(16'h00A5, 8, 1);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Sending 8-bit 0x54 (01010100)", test_num);
        reset_dut();
        send_bits(16'h0054, 8, 1);

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Sending partial byte (4 bits)", test_num);
        reset_dut();
        send_bits(16'h000F, 4, 1);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Sending bits with ssel HIGH (inactive)", test_num);
        reset_dut();
        ssel = 1;
        send_bits(16'h00FF, 8, 0);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Sending two consecutive bytes (0xAA, 0x55)", test_num);
        reset_dut();
        send_bits(16'h00AA, 8, 1);
        send_bits(16'h0055, 8, 1);

        #1;


        check_outputs(1'b1, 1'b1);
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
        input expected_miso;
        input expected_recived_status;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_recived_status === (expected_recived_status ^ recived_status ^ expected_recived_status)) begin
                $display("PASS");
                $display("  Outputs: miso=%b, recived_status=%b",
                         miso, recived_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b, recived_status=%b",
                         expected_miso, expected_recived_status);
                $display("  Got:      miso=%b, recived_status=%b",
                         miso, recived_status);
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
        $dumpvars(0,clk, mosi, rst_n, sck, ssel, miso, recived_status);
    end

endmodule
