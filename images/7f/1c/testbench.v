`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg escribirhours;
    reg [3:0] hones;
    reg [3:0] htens;
    reg leerhours;
    reg lrda;
    reg lrdb;
    reg lrdc;
    reg lrdd;
    reg lrde;
    reg lrdf;
    reg lrdg;
    reg lrdh;
    reg rstreghours;
    wire [3:0] hour1;
    wire [3:0] hour2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .escribirhours(escribirhours),
        .hones(hones),
        .htens(htens),
        .leerhours(leerhours),
        .lrda(lrda),
        .lrdb(lrdb),
        .lrdc(lrdc),
        .lrdd(lrdd),
        .lrde(lrde),
        .lrdf(lrdf),
        .lrdg(lrdg),
        .lrdh(lrdh),
        .rstreghours(rstreghours),
        .hour1(hour1),
        .hour2(hour2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rstreghours = 1;
        leerhours = 0;
        escribirhours = 0;
        lrda = 0; lrdb = 0; lrdc = 0; lrdd = 0;
        lrde = 0; lrdf = 0; lrdg = 0; lrdh = 0;
        htens = 4'b0;
        hones = 4'b0;
        @(posedge clk);
        #1;
        rstreghours = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Write Operation");
        reset_dut();
        escribirhours = 1;
        htens = 4'd1;
        hones = 4'd2;
        @(posedge clk);
        #1;
        escribirhours = 0;
        #1;

        check_outputs(4'd1, 4'd2);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Basic Read Operation (Bit-level)");
        reset_dut();
        leerhours = 1;

        lrda = 0; lrdb = 1; lrdc = 0; lrdd = 1;
        lrde = 1; lrdf = 0; lrdg = 1; lrdh = 0;
        @(posedge clk);
        #1;
        leerhours = 0;
        #1;

        check_outputs(4'hA, 4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Reset Priority over Write");
        reset_dut();
        rstreghours = 1;
        escribirhours = 1;
        htens = 4'hF;
        hones = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Reset Priority over Read");
        reset_dut();
        rstreghours = 1;
        leerhours = 1;
        lrda = 1; lrdb = 1; lrdc = 1; lrdd = 1;
        lrde = 1; lrdf = 1; lrdg = 1; lrdh = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Data Retention");
        reset_dut();

        escribirhours = 1;
        htens = 4'h3;
        hones = 4'h9;
        @(posedge clk);
        #1;

        escribirhours = 0;
        htens = 4'h0;
        hones = 4'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3, 4'h9);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Max Value Write");
        reset_dut();
        escribirhours = 1;
        htens = 4'hF;
        hones = 4'hF;
        @(posedge clk);
        #1;
        escribirhours = 0;
        #1;

        check_outputs(4'hF, 4'hF);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Sequential Updates");
        reset_dut();

        escribirhours = 1;
        htens = 4'h1;
        hones = 4'h2;
        @(posedge clk);
        #1;

        escribirhours = 0;
        leerhours = 1;
        lrda = 1; lrdb = 1; lrdc = 0; lrdd = 0;
        lrde = 0; lrdf = 0; lrdg = 1; lrdh = 1;
        @(posedge clk);
        #1;
        leerhours = 0;
        #1;

        check_outputs(4'h3, 4'hC);
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
        input [3:0] expected_hour1;
        input [3:0] expected_hour2;
        begin
            if (expected_hour1 === (expected_hour1 ^ hour1 ^ expected_hour1) &&
                expected_hour2 === (expected_hour2 ^ hour2 ^ expected_hour2)) begin
                $display("PASS");
                $display("  Outputs: hour1=%h, hour2=%h",
                         hour1, hour2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hour1=%h, hour2=%h",
                         expected_hour1, expected_hour2);
                $display("  Got:      hour1=%h, hour2=%h",
                         hour1, hour2);
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
        $dumpvars(0,clk, escribirhours, hones, htens, leerhours, lrda, lrdb, lrdc, lrdd, lrde, lrdf, lrdg, lrdh, rstreghours, hour1, hour2);
    end

endmodule
