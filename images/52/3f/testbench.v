`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [30:0] di;
    reg [4:0] ra1;
    reg [4:0] ra2;
    reg [4:0] wa;
    reg we;
    wire [30:0] do1;
    wire [30:0] do2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .di(di),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .we(we),
        .do1(do1),
        .do2(do2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            wa = 0;
            ra1 = 0;
            ra2 = 0;
            di = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Single Read");
            reset_dut();


            we = 1; wa = 5; di = 31'h12345678;
            @(posedge clk); #1;


            we = 0; ra1 = 5; ra2 = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(31'h12345678, 31'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Dual Port Read");
            reset_dut();


            we = 1; wa = 10; di = 31'h5A5A5A5A;
            @(posedge clk); #1;


            we = 1; wa = 20; di = 31'hA5A5A5A5;
            @(posedge clk); #1;


            we = 0; ra1 = 10; ra2 = 20;
            @(posedge clk); #1;

            #1;


            check_outputs(31'h5A5A5A5A, 31'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Low (Should not overwrite)");
            reset_dut();


            we = 1; wa = 2; di = 31'h7FFFFFFF;
            @(posedge clk); #1;


            we = 0; wa = 2; di = 31'h00000001;
            @(posedge clk); #1;


            ra1 = 2; ra2 = 2;
            @(posedge clk); #1;

            #1;


            check_outputs(31'h7FFFFFFF, 31'h7FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write and Read same cycle");
            reset_dut();


            we = 1; wa = 15; ra1 = 15; di = 31'h0FAB0FAB;
            @(posedge clk); #1;



            @(posedge clk); #1;
            #1;

            check_outputs(31'h0FAB0FAB, 31'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Max and Min Address Check");
            reset_dut();


            we = 1; wa = 0; di = 31'h11111111;
            @(posedge clk); #1;


            we = 1; wa = 31; di = 31'h77777777;
            @(posedge clk); #1;


            we = 0; ra1 = 0; ra2 = 31;
            @(posedge clk); #1;

            #1;


            check_outputs(31'h11111111, 31'h77777777);
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
        input [30:0] expected_do1;
        input [30:0] expected_do2;
        begin
            if (expected_do1 === (expected_do1 ^ do1 ^ expected_do1) &&
                expected_do2 === (expected_do2 ^ do2 ^ expected_do2)) begin
                $display("PASS");
                $display("  Outputs: do1=%h, do2=%h",
                         do1, do2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: do1=%h, do2=%h",
                         expected_do1, expected_do2);
                $display("  Got:      do1=%h, do2=%h",
                         do1, do2);
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
        $dumpvars(0,clk, di, ra1, ra2, wa, we, do1, do2);
    end

endmodule
