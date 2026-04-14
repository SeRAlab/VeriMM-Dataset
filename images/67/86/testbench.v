`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] first_data_in;
    reg [7:0] second_data_in;
    reg system_clock;
    reg system_rst_n;
    wire [7:0] data_out_and_gate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .first_data_in(first_data_in),
        .second_data_in(second_data_in),
        .system_clock(system_clock),
        .system_rst_n(system_rst_n),
        .data_out_and_gate(data_out_and_gate)
    );

    // Clock generation (10ns period)
    initial begin
        system_clock = 0;
        forever #5 system_clock = ~system_clock;
    end

        task reset_dut;

        begin
            system_rst_n = 1'b0;
            first_data_in = 8'h00;
            second_data_in = 8'h00;
            @(posedge system_clock);
            #1;
            system_rst_n = 1'b1;
            @(posedge system_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All ones ANDed");
            reset_dut();
            first_data_in = 8'hFF;
            second_data_in = 8'hFF;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All zeros ANDed");
            reset_dut();
            first_data_in = 8'h00;
            second_data_in = 8'h00;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Complementary bit patterns");
            reset_dut();
            first_data_in = 8'hAA;
            second_data_in = 8'h55;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Half and half patterns");
            reset_dut();
            first_data_in = 8'hF0;
            second_data_in = 8'hCC;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single bit matching");
            reset_dut();
            first_data_in = 8'h01;
            second_data_in = 8'h01;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Mixed bit matching");
            reset_dut();
            first_data_in = 8'h12;
            second_data_in = 8'h34;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Identity property (AND with FF)");
            reset_dut();
            first_data_in = 8'hA5;
            second_data_in = 8'hFF;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Zero property (AND with 00)");
            reset_dut();
            first_data_in = 8'hFF;
            second_data_in = 8'h00;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Random hex pattern 1");
            reset_dut();
            first_data_in = 8'hDB;
            second_data_in = 8'h76;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'h52);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Random hex pattern 2");
            reset_dut();
            first_data_in = 8'hDE;
            second_data_in = 8'hAD;
            @(posedge system_clock);
            #1;
            #1;

            check_outputs(8'h8C);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_data_out_and_gate;
        begin
            if (expected_data_out_and_gate === (expected_data_out_and_gate ^ data_out_and_gate ^ expected_data_out_and_gate)) begin
                $display("PASS");
                $display("  Outputs: data_out_and_gate=%h",
                         data_out_and_gate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_and_gate=%h",
                         expected_data_out_and_gate);
                $display("  Got:      data_out_and_gate=%h",
                         data_out_and_gate);
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
        $dumpvars(0,first_data_in, second_data_in, system_clock, system_rst_n, data_out_and_gate);
    end

endmodule
