`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] a;
    reg cpu_clock;
    reg din;
    reg memreg_rd;
    reg port_wr;
    reg [2:0] volnum;
    reg volports_enabled;
    wire [2:0] snd_addr;
    wire [7:0] snd_data;
    wire snd_datnvol;
    wire snd_wrtoggle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .cpu_clock(cpu_clock),
        .din(din),
        .memreg_rd(memreg_rd),
        .port_wr(port_wr),
        .volnum(volnum),
        .volports_enabled(volports_enabled),
        .snd_addr(snd_addr),
        .snd_data(snd_data),
        .snd_datnvol(snd_datnvol),
        .snd_wrtoggle(snd_wrtoggle)
    );

    // Clock generation (10ns period)
    initial begin
        cpu_clock = 0;
        forever #5 cpu_clock = ~cpu_clock;
    end

        task reset_dut;

    begin
        a = 0;
        din = 0;
        memreg_rd = 0;
        port_wr = 0;
        volnum = 0;
        volports_enabled = 0;
        @(posedge cpu_clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;


        a = 11'h5AA;
        memreg_rd = 1;
        @(posedge cpu_clock);
        #1;
        memreg_rd = 0;

        #1;


        check_outputs(3'b101, 8'hAA, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        volports_enabled = 1;
        port_wr = 1;
        volnum = 3'h3;
        din = 1'b1;
        @(posedge cpu_clock);
        #1;
        volports_enabled = 0;
        port_wr = 0;



        #1;




        check_outputs(3'h3, 8'h01, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        a = 11'h111;
        memreg_rd = 1;
        @(posedge cpu_clock);
        #2;

        a = 11'h222;
        memreg_rd = 1;
        @(posedge cpu_clock);
        #1;
        memreg_rd = 0;

        #1;


        check_outputs(3'b010, 8'h22, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        a = 11'h7FF;
        memreg_rd = 1;
        @(posedge cpu_clock);
        #1;
        memreg_rd = 0;

        #1;


        check_outputs(3'b111, 8'hFF, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        a = 11'hFFF;
        memreg_rd = 0;
        port_wr = 0;
        volports_enabled = 0;
        @(posedge cpu_clock);
        #1;

        #1;


        check_outputs(3'b000, 8'h00, 1'b0, 1'b0);
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
        input [2:0] expected_snd_addr;
        input [7:0] expected_snd_data;
        input expected_snd_datnvol;
        input expected_snd_wrtoggle;
        begin
            if (expected_snd_addr === (expected_snd_addr ^ snd_addr ^ expected_snd_addr) &&
                expected_snd_data === (expected_snd_data ^ snd_data ^ expected_snd_data) &&
                expected_snd_datnvol === (expected_snd_datnvol ^ snd_datnvol ^ expected_snd_datnvol) &&
                expected_snd_wrtoggle === (expected_snd_wrtoggle ^ snd_wrtoggle ^ expected_snd_wrtoggle)) begin
                $display("PASS");
                $display("  Outputs: snd_addr=%h, snd_data=%h, snd_datnvol=%b, snd_wrtoggle=%b",
                         snd_addr, snd_data, snd_datnvol, snd_wrtoggle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: snd_addr=%h, snd_data=%h, snd_datnvol=%b, snd_wrtoggle=%b",
                         expected_snd_addr, expected_snd_data, expected_snd_datnvol, expected_snd_wrtoggle);
                $display("  Got:      snd_addr=%h, snd_data=%h, snd_datnvol=%b, snd_wrtoggle=%b",
                         snd_addr, snd_data, snd_datnvol, snd_wrtoggle);
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
        $dumpvars(0,a, cpu_clock, din, memreg_rd, port_wr, volnum, volports_enabled, snd_addr, snd_data, snd_datnvol, snd_wrtoggle);
    end

endmodule
