`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] data_i;
    reg reset;
    reg writeEn;
    wire [7:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_i(data_i),
        .reset(reset),
        .writeEn(writeEn),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            writeEn = 0;
            data_i = 8'h00;
            @(negedge clock);
            reset = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Basic Write 0xAA", test_num);
            reset_dut();
            data_i = 8'hAA;
            writeEn = 1;
            @(negedge clock);
            writeEn = 0;
            @(negedge clock);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Write Disable (Hold) Check", test_num);
            reset_dut();

            data_i = 8'h55;
            writeEn = 1;
            @(negedge clock);

            data_i = 8'hFF;
            writeEn = 0;
            @(negedge clock);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Successive Writes", test_num);
            reset_dut();
            writeEn = 1;
            data_i = 8'h11;
            @(negedge clock);
            data_i = 8'h22;
            @(negedge clock);
            data_i = 8'h33;
            @(negedge clock);
            writeEn = 0;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Boundary Value Write (0xFF)", test_num);
            reset_dut();
            writeEn = 1;
            data_i = 8'hFF;
            @(negedge clock);
            writeEn = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Reset Priority over Write Enable", test_num);
            reset_dut();
            writeEn = 1;
            data_i = 8'hCC;
            @(negedge clock);

            reset = 1;
            @(negedge clock);
            reset = 0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,clock, data_i, reset, writeEn, data_o);
    end

endmodule
