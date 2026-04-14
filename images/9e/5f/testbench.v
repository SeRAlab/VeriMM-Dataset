`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg init;
    reg [7:0] mem_addr;
    reg [15:0] mem_dat_in;
    reg rd;
    reg wr;
    wire [15:0] mem_dat_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .init(init),
        .mem_addr(mem_addr),
        .mem_dat_in(mem_dat_in),
        .rd(rd),
        .wr(wr),
        .mem_dat_out(mem_dat_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            init = 0;
            mem_addr = 0;
            mem_dat_in = 0;
            rd = 0;
            wr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();


            init = 1;
            wr = 1;
            rd = 0;
            mem_addr = 8'h10;
            mem_dat_in = 16'hABCD;
            @(posedge clk);
            #1;


            wr = 0;
            rd = 1;
            mem_addr = 8'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Multiple writes and sequential reads");
            reset_dut();

            init = 1;


            wr = 1;
            mem_addr = 8'h00;
            mem_dat_in = 16'h1111;
            @(posedge clk);
            #1;


            mem_addr = 8'hFF;
            mem_dat_in = 16'hFFFF;
            @(posedge clk);
            #1;


            wr = 0;
            rd = 1;
            mem_addr = 8'h00;
            @(posedge clk);
            #1;


            if (mem_dat_out !== 16'h1111) begin
                #1;

                check_outputs(16'h1111);
            end else begin

                mem_addr = 8'hFF;
                @(posedge clk);
                #1;
                #1;

                check_outputs(16'hFFFF);
            end
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting existing data");
            reset_dut();

            init = 1;


            wr = 1;
            mem_addr = 8'h55;
            mem_dat_in = 16'hAAAA;
            @(posedge clk);
            #1;


            mem_dat_in = 16'h5555;
            @(posedge clk);
            #1;


            wr = 0;
            rd = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Init signal gating (Write)");
            reset_dut();


            init = 1;
            wr = 1;
            mem_addr = 8'h20;
            mem_dat_in = 16'h1234;
            @(posedge clk);
            #1;


            init = 0;
            wr = 1;
            mem_dat_in = 16'h9999;
            @(posedge clk);
            #1;


            init = 1;
            wr = 0;
            rd = 1;
            mem_addr = 8'h20;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary address check (255)");
            reset_dut();

            init = 1;
            wr = 1;
            mem_addr = 8'd255;
            mem_dat_in = 16'hE0E0;
            @(posedge clk);
            #1;

            wr = 0;
            rd = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hE0E0);
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
        input [15:0] expected_mem_dat_out;
        begin
            if (expected_mem_dat_out === (expected_mem_dat_out ^ mem_dat_out ^ expected_mem_dat_out)) begin
                $display("PASS");
                $display("  Outputs: mem_dat_out=%h",
                         mem_dat_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_dat_out=%h",
                         expected_mem_dat_out);
                $display("  Got:      mem_dat_out=%h",
                         mem_dat_out);
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
        $dumpvars(0,clk, init, mem_addr, mem_dat_in, rd, wr, mem_dat_out);
    end

endmodule
