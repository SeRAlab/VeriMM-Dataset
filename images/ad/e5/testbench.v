`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cen;
    reg clk;
    reg ina;
    reg inb;
    reg rst;
    wire outa;
    wire outb;
    wire outc;
    wire outd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cen(cen),
        .clk(clk),
        .ina(ina),
        .inb(inb),
        .rst(rst),
        .outa(outa),
        .outb(outb),
        .outc(outc),
        .outd(outd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cen = 1;
            ina = 0;
            inb = 0;
            @(posedge clk);
            #1;
            rst = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Synchronous Reset Verification");
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Clock Enable (cen) Check");
            reset_dut();
            cen = 0;
            ina = 1;
            inb = 1;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Propagation to outa (temp[3])");
            reset_dut();
            cen = 1;
            ina = 0;
            inb = 1;
            @(posedge clk);
            ina = 0;
            inb = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Propagation to outb (temp[5])");
            reset_dut();
            cen = 1;
            ina = 0;
            inb = 1;
            @(posedge clk);
            ina = 0; inb = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Reset Priority Check");
            reset_dut();
            cen = 1;
            ina = 1;
            inb = 1;
            repeat(2) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Propagation to outc (temp[9])");
            reset_dut();
            cen = 1;
            ina = 0;
            inb = 1;
            @(posedge clk);
            ina = 0; inb = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
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
        input expected_outa;
        input expected_outb;
        input expected_outc;
        input expected_outd;
        begin
            if (expected_outa === (expected_outa ^ outa ^ expected_outa) &&
                expected_outb === (expected_outb ^ outb ^ expected_outb) &&
                expected_outc === (expected_outc ^ outc ^ expected_outc) &&
                expected_outd === (expected_outd ^ outd ^ expected_outd)) begin
                $display("PASS");
                $display("  Outputs: outa=%b, outb=%b, outc=%b, outd=%b",
                         outa, outb, outc, outd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outa=%b, outb=%b, outc=%b, outd=%b",
                         expected_outa, expected_outb, expected_outc, expected_outd);
                $display("  Got:      outa=%b, outb=%b, outc=%b, outd=%b",
                         outa, outb, outc, outd);
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
        $dumpvars(0,cen, clk, ina, inb, rst, outa, outb, outc, outd);
    end

endmodule
