`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data;
    reg enable;
    reg reset;
    wire [7:0] crc;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .enable(enable),
        .reset(reset),
        .crc(crc),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 16'h0000;
            @(posedge enable);
            #1;
            reset = 0;
            @(posedge enable);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and All-Zeros Data", test_num);
            reset_dut();
            data = 16'h0000;
            @(posedge enable);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data with LSB Set", test_num);
            reset_dut();
            data = 16'h0001;
            @(posedge enable);
            #1;


            #1;



            check_outputs(8'h07, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bit Pattern (0xAAAA)", test_num);
            reset_dut();
            data = 16'hAAAA;
            @(posedge enable);
            #1;

            #1;


            check_outputs(8'h1B, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All-Ones Data (0xFFFF)", test_num);
            reset_dut();
            data = 16'hFFFF;
            @(posedge enable);
            #1;

            #1;


            check_outputs(8'hA1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Valid Codeword Check", test_num);
            reset_dut();


            data = 16'h0E07;
            @(posedge enable);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_crc;
        input expected_valid;
        begin
            if (expected_crc === (expected_crc ^ crc ^ expected_crc) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: crc=%h, valid=%b",
                         crc, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h, valid=%b",
                         expected_crc, expected_valid);
                $display("  Got:      crc=%h, valid=%b",
                         crc, valid);
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
        $dumpvars(0,data, enable, reset, crc, valid);
    end

endmodule
