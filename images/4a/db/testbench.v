`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire data_out;
    wire [6:0] shift_regs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .shift_regs(shift_regs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: 6-bit match at [5:0]...");
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 7'b0101011);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 6-bit match at [6:1]...");
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 7'b1010110);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 6-bit match at [5:0] with leading data...");
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 7'b1101011);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All zeros...");
            reset_dut();
            repeat(7) begin
                data_in = 0; @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b0, 7'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All ones...");
            reset_dut();
            repeat(7) begin
                data_in = 1; @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b0, 7'h7F);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Near match 101010...");
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 7'b0101010);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset during sequence...");
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            reset = 1; @(posedge clk);
            reset = 0;
            data_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 7'h01);
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
        input expected_data_out;
        input [6:0] expected_shift_regs;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_shift_regs === (expected_shift_regs ^ shift_regs ^ expected_shift_regs)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, shift_regs=%h",
                         data_out, shift_regs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, shift_regs=%h",
                         expected_data_out, expected_shift_regs);
                $display("  Got:      data_out=%b, shift_regs=%h",
                         data_out, shift_regs);
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
        $dumpvars(0,clk, data_in, reset, data_out, shift_regs);
    end

endmodule
