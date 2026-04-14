`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg spi_clk;
    reg [2:0] spi_csn;
    reg spi_mosi;
    wire spi_dir;
    wire spi_miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .spi_clk(spi_clk),
        .spi_csn(spi_csn),
        .spi_mosi(spi_mosi),
        .spi_dir(spi_dir),
        .spi_miso(spi_miso)
    );

    // Clock generation (10ns period)
    initial begin
        spi_clk = 0;
        forever #5 spi_clk = ~spi_clk;
    end

        task reset_dut;

        begin
            spi_csn = 3'b111;
            spi_mosi = 0;
            test_num = test_num + 1;
            repeat(2) @(posedge spi_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: Idle State...");


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: Write Operation Start...");
            spi_csn = 3'b110;
            spi_mosi = 1'b0;
            @(posedge spi_clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: Read Operation Transition...");
            spi_csn = 3'b110;
            spi_mosi = 1'b1;
            @(posedge spi_clk);
            #1;

            repeat(8) @(posedge spi_clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: CSN Termination...");
            spi_csn = 3'b110;
            spi_mosi = 1'b0;
            @(posedge spi_clk);
            @(posedge spi_clk);
            #1;
            spi_csn = 3'b111;
            @(posedge spi_clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: Long Transaction...");
            spi_csn = 3'b011;
            spi_mosi = 1'b0;
            @(posedge spi_clk);
            #1;

            repeat(32) @(posedge spi_clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_spi_dir;
        input expected_spi_miso;
        begin
            if (expected_spi_dir === (expected_spi_dir ^ spi_dir ^ expected_spi_dir) &&
                expected_spi_miso === (expected_spi_miso ^ spi_miso ^ expected_spi_miso)) begin
                $display("PASS");
                $display("  Outputs: spi_dir=%b, spi_miso=%b",
                         spi_dir, spi_miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spi_dir=%b, spi_miso=%b",
                         expected_spi_dir, expected_spi_miso);
                $display("  Got:      spi_dir=%b, spi_miso=%b",
                         spi_dir, spi_miso);
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
        $dumpvars(0,spi_clk, spi_csn, spi_mosi, spi_dir, spi_miso);
    end

endmodule
