`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg init;
    reg reset;
    wire [15:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .init(init),
        .reset(reset),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            init = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initialization", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            enable = 1;
            init = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Byte (0x31)", test_num);
            reset_dut();


            @(posedge clk);
            #1;
            enable = 1;
            init = 1;
            @(posedge clk);


            #1;
            init = 0;
            data_in = 8'h31;
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'hDE91);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multi-byte Stream ('123')", test_num);
            reset_dut();

            @(posedge clk);
            #1; enable = 1; init = 1;
            @(posedge clk);

            #1; init = 0; data_in = 8'h31;
            @(posedge clk);
            #1; data_in = 8'h32;
            @(posedge clk);
            #1; data_in = 8'h33;
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'h5D7B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable Signal Logic", test_num);
            reset_dut();

            @(posedge clk);
            #1; enable = 1; init = 1;
            @(posedge clk);

            #1; init = 0; data_in = 8'h31;
            @(posedge clk);

            #1; enable = 0; data_in = 8'hFF;
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'hDE91);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            #1; enable = 1; init = 1;
            @(posedge clk);

            #1; init = 0; data_in = 8'hAA;
            @(posedge clk);

            #1; reset = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, enable, init, reset, crc_out);
    end

endmodule
