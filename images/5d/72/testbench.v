`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1023:0] in;
    reg in_valid;
    reg out_ready;
    reg [1023:0] sRA;
    reg [1023:0] sW;
    reg [1023:0] sWA;
    wire [1:0] sB;
    wire [1023:0] sR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .sRA(sRA),
        .sW(sW),
        .sWA(sWA),
        .sB(sB),
        .sR(sR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_valid = 0;
            out_ready = 0;
            in = 0;
            sRA = 0;
            sW = 0;
            sWA = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Sequential Write and Read...");
            reset_dut();


            in = 1024'hAAAA;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;


            sRA = 1024'h0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00, 1024'hAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple Sequential Writes...");
            reset_dut();


            in = 1024'h1111;
            in_valid = 1;
            @(posedge clk);
            #1;

            in = 1024'h2222;
            @(posedge clk);
            #1;

            in = 1024'h3333;
            @(posedge clk);
            #1;
            in_valid = 0;


            sRA = 1024'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1024'h3333);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Out of Bounds Read Check...");
            reset_dut();



            sRA = 1024'd1024;
            @(posedge clk);
            #1;




            if (sB != 2'b00 && sR === 1024'h0) begin
                $display("PASS: Error correctly signaled for OOB read.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Expected sB != 0 and sR = 0, Got sB=%h, sR=%h", sB, sR);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Last Valid Address Check...");
            reset_dut();


            in_valid = 1;
            for (i = 0; i < 1023; i = i + 1) begin
                in = i;
                @(posedge clk);
                #1;
            end


            in = 1024'hFFFF;
            @(posedge clk);
            #1;
            in_valid = 0;


            sRA = 1024'd1023;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1024'hFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Random Access Write (sWA/sW)...");
            reset_dut();


            sWA = 1024'd500;
            sW = 1024'h500D;

            @(posedge clk);
            #1;


            sRA = 1024'd500;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1024'h500D);
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
        input [1:0] expected_sB;
        input [1023:0] expected_sR;
        begin
            if (expected_sB === (expected_sB ^ sB ^ expected_sB) &&
                expected_sR === (expected_sR ^ sR ^ expected_sR)) begin
                $display("PASS");
                $display("  Outputs: sB=%h, sR=%h",
                         sB, sR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sB=%h, sR=%h",
                         expected_sB, expected_sR);
                $display("  Got:      sB=%h, sR=%h",
                         sB, sR);
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
        $dumpvars(0,clk, in, in_valid, out_ready, sRA, sW, sWA, sB, sR);
    end

endmodule
