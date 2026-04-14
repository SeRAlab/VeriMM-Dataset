`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg clk;
    reg [7:0] di;
    reg [3:0] dpra;
    reg we;
    wire [7:0] dpo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .di(di),
        .dpra(dpra),
        .we(we),
        .dpo(dpo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            di = 0;
            dpra = 0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Address 0");
            reset_dut();


            we = 1;
            a = 4'h0;
            di = 8'hA5;
            @(posedge clk);
            #1;


            we = 0;
            dpra = 4'h0;
            #2;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Boundary Address Check (Address 15)");
            reset_dut();

            we = 1;
            a = 4'hF;
            di = 8'h5A;
            @(posedge clk);
            #1;

            we = 0;
            dpra = 4'hF;
            #2;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify Write Enable signal");
            reset_dut();


            we = 1;
            a = 4'h5;
            di = 8'h11;
            @(posedge clk);
            #1;


            we = 0;
            a = 4'h5;
            di = 8'hFF;
            @(posedge clk);
            #1;

            dpra = 4'h5;
            #2;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Dual Port - Write to A while reading from B");
            reset_dut();


            we = 1;
            a = 4'h2;
            di = 8'h77;
            @(posedge clk);
            #1;


            a = 4'h3;
            di = 8'h88;
            dpra = 4'h2;
            we = 1;
            #2;

            #1;


            check_outputs(8'h77);

            @(posedge clk);
            #1;
            we = 0;
            dpra = 4'h3;
            #2;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite existing data");
            reset_dut();


            we = 1;
            a = 4'hA;
            di = 8'h10;
            @(posedge clk);
            #1;


            di = 8'h20;
            @(posedge clk);
            #1;

            we = 0;
            dpra = 4'hA;
            #2;

            #1;


            check_outputs(8'h20);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify Read is Asynchronous");
            reset_dut();


            we = 1; a = 4'h1; di = 8'h01; @(posedge clk); #1;
            we = 1; a = 4'h2; di = 8'h02; @(posedge clk); #1;

            we = 0;


            dpra = 4'h1;
            #5;


            dpra = 4'h2;
            #5;

            #1;


            check_outputs(8'h02);
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
        input [7:0] expected_dpo;
        begin
            if (expected_dpo === (expected_dpo ^ dpo ^ expected_dpo)) begin
                $display("PASS");
                $display("  Outputs: dpo=%h",
                         dpo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dpo=%h",
                         expected_dpo);
                $display("  Got:      dpo=%h",
                         dpo);
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
        $dumpvars(0,a, clk, di, dpra, we, dpo);
    end

endmodule
