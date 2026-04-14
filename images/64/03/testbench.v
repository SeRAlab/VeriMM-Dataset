`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg enable;
    reg rst;
    reg shift;
    reg sync_rst;
    wire crc_match;
    wire crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .rst(rst),
        .shift(shift),
        .sync_rst(sync_rst),
        .crc_match(crc_match),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            data = 0;
            enable = 0;
            shift = 0;
            sync_rst = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Asynchronous Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Synchronous Reset", test_num);
            reset_dut();


            enable = 1;
            shift = 1;
            data = 0;
            repeat (5) @(posedge clk);


            sync_rst = 1;
            @(posedge clk);
            sync_rst = 0;
            enable = 0;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Shift 32 bits of 0 to clear CRC", test_num);
            reset_dut();

            enable = 1;
            shift = 1;
            data = 0;


            repeat (32) @(posedge clk);

            enable = 0;
            shift = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable signal frozen state", test_num);
            reset_dut();

            enable = 0;
            shift = 1;
            data = 0;
            repeat (10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: CRC Calculation transition", test_num);
            reset_dut();

            enable = 1;
            shift = 0;
            data = 1;
            @(posedge clk);
            data = 0;
            @(posedge clk);

            enable = 0;


            if (crc_match === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: CRC changed from reset state.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: CRC calculation did not modify register.");
            end
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
        input expected_crc_match;
        input expected_crc_out;
        begin
            if (expected_crc_match === (expected_crc_match ^ crc_match ^ expected_crc_match) &&
                expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_match=%b, crc_out=%b",
                         crc_match, crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_match=%b, crc_out=%b",
                         expected_crc_match, expected_crc_out);
                $display("  Got:      crc_match=%b, crc_out=%b",
                         crc_match, crc_out);
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
        $dumpvars(0,clk, data, enable, rst, shift, sync_rst, crc_match, crc_out);
    end

endmodule
