`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [7:0] data;
    wire mosi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .data(data),
        .mosi(mosi)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cs = 0;
            data = 8'h00;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Checking tri-state (CS=0)...");
            cs = 0;
            #2;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Checking MSB of 0x80 (Expected: 1)...");
            data = 8'h80;
            cs = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Checking MSB of 0x7F (Expected: 0)...");
            data = 8'h7F;
            cs = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Checking Bit 6 of 0x40 (Expected: 1)...");
            data = 8'h40;
            cs = 1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Checking LSB of 0x01 (Expected: 1)...");
            data = 8'h01;
            cs = 1;
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Checking LSB of 0xFE (Expected: 0)...");
            data = 8'hFE;
            cs = 1;
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Checking High-Z after transmission ends...");
            data = 8'hFF;
            cs = 1;
            repeat(4) @(posedge clk);
            cs = 0;
            #2;
            #1;

            check_outputs(1'bz);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input expected_mosi;
        begin
            if (expected_mosi === (expected_mosi ^ mosi ^ expected_mosi)) begin
                $display("PASS");
                $display("  Outputs: mosi=%b",
                         mosi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mosi=%b",
                         expected_mosi);
                $display("  Got:      mosi=%b",
                         mosi);
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
        $dumpvars(0,clk, cs, data, mosi);
    end

endmodule
