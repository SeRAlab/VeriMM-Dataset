`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] data;
    reg reset_n;
    reg update;
    wire [3:0] bit_gain;
    wire [31:0] inc_phi;
    wire [3:0] occupation;
    wire [3:0] waveform;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .reset_n(reset_n),
        .update(update),
        .bit_gain(bit_gain),
        .inc_phi(inc_phi),
        .occupation(occupation),
        .waveform(waveform)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            update = 0;
            addr = 0;
            data = 0;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task write_reg;

        input [7:0] w_addr;
        input [7:0] w_data;
        begin
            @(posedge clk);
            addr = w_addr;
            data = w_data;
            update = 0;
            @(posedge clk);
            #1 update = 1;
            @(posedge clk);
            #1 update = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Reset state check...");
            reset_dut();

            #1;


            check_outputs(4'h0, 32'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Register 0 (occupation/waveform) check...");
            reset_dut();

            write_reg(8'h00, 8'hA5);
            #1;

            check_outputs(4'h0, 32'h0, 4'hA, 4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Registers 1-4 (inc_phi) check...");
            reset_dut();

            write_reg(8'h01, 8'h11);
            write_reg(8'h02, 8'h22);
            write_reg(8'h03, 8'h33);
            write_reg(8'h04, 8'h44);
            #1;

            check_outputs(4'h0, 32'h44332211, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Register 5 (bit_gain) check...");
            reset_dut();

            write_reg(8'h05, 8'h0F);
            #1;

            check_outputs(4'hF, 32'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full register set check...");
            reset_dut();
            write_reg(8'h00, 8'h12);
            write_reg(8'h01, 8'hDE);
            write_reg(8'h02, 8'hAD);
            write_reg(8'h03, 8'hBE);
            write_reg(8'h04, 8'hEF);
            write_reg(8'h05, 8'h09);
            #1;

            check_outputs(4'h9, 32'hEFBEADDE, 4'h1, 4'h2);
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
        input [3:0] expected_bit_gain;
        input [31:0] expected_inc_phi;
        input [3:0] expected_occupation;
        input [3:0] expected_waveform;
        begin
            if (expected_bit_gain === (expected_bit_gain ^ bit_gain ^ expected_bit_gain) &&
                expected_inc_phi === (expected_inc_phi ^ inc_phi ^ expected_inc_phi) &&
                expected_occupation === (expected_occupation ^ occupation ^ expected_occupation) &&
                expected_waveform === (expected_waveform ^ waveform ^ expected_waveform)) begin
                $display("PASS");
                $display("  Outputs: bit_gain=%h, inc_phi=%h, occupation=%h, waveform=%h",
                         bit_gain, inc_phi, occupation, waveform);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_gain=%h, inc_phi=%h, occupation=%h, waveform=%h",
                         expected_bit_gain, expected_inc_phi, expected_occupation, expected_waveform);
                $display("  Got:      bit_gain=%h, inc_phi=%h, occupation=%h, waveform=%h",
                         bit_gain, inc_phi, occupation, waveform);
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
        $dumpvars(0,addr, clk, data, reset_n, update, bit_gain, inc_phi, occupation, waveform);
    end

endmodule
