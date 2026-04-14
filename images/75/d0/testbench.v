`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AD;
    reg [7:0] DI;
    reg clk;
    reg cs;
    reg rst;
    reg rw;
    wire [7:0] DO;
    wire bram_disable;
    wire brom_disable;
    wire [3:0] page;
    wire rampage_lock;
    wire sysboot_lock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AD(AD),
        .DI(DI),
        .clk(clk),
        .cs(cs),
        .rst(rst),
        .rw(rw),
        .DO(DO),
        .bram_disable(bram_disable),
        .brom_disable(brom_disable),
        .page(page),
        .rampage_lock(rampage_lock),
        .sysboot_lock(sysboot_lock)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            AD = 0;
            DI = 0;
            rw = 1;
            cs = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check");
            reset_dut();

            cs = 1; rw = 1; AD = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 0, 0, 4'h0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Page Selection (AD=1)");
            reset_dut();
            cs = 1; rw = 0; AD = 1; DI = 8'h05;
            @(posedge clk);
            #1 rw = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h05, 0, 0, 4'h5, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Control Configuration (AD=0)");
            reset_dut();
            cs = 1; rw = 0; AD = 0; DI = 8'h0C;
            @(posedge clk);
            #1 rw = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h0C, 1, 1, 4'h0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Page Lock Mechanism");
            reset_dut();

            cs = 1; rw = 0; AD = 1; DI = 8'h02;
            @(posedge clk);

            #1 AD = 0; DI = 8'h01;
            @(posedge clk);

            #1 AD = 1; DI = 8'h07;
            @(posedge clk);
            #1 rw = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h02, 0, 0, 4'h2, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Chip Select Verification");
            reset_dut();
            cs = 0; rw = 0; AD = 1; DI = 8'h0F;
            @(posedge clk);
            #1 cs = 1; rw = 1; AD = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 0, 0, 4'h0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: System Boot Lock and Disables");
            reset_dut();
            cs = 1; rw = 0; AD = 0; DI = 8'h0E;
            @(posedge clk);
            #1 rw = 1;
            @(posedge clk);
            #1;

            check_outputs(8'h0E, 1, 1, 4'h0, 0, 1);
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
        input [7:0] expected_DO;
        input expected_bram_disable;
        input expected_brom_disable;
        input [3:0] expected_page;
        input expected_rampage_lock;
        input expected_sysboot_lock;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO) &&
                expected_bram_disable === (expected_bram_disable ^ bram_disable ^ expected_bram_disable) &&
                expected_brom_disable === (expected_brom_disable ^ brom_disable ^ expected_brom_disable) &&
                expected_page === (expected_page ^ page ^ expected_page) &&
                expected_rampage_lock === (expected_rampage_lock ^ rampage_lock ^ expected_rampage_lock) &&
                expected_sysboot_lock === (expected_sysboot_lock ^ sysboot_lock ^ expected_sysboot_lock)) begin
                $display("PASS");
                $display("  Outputs: DO=%h, bram_disable=%b, brom_disable=%b, page=%h, rampage_lock=%b, sysboot_lock=%b",
                         DO, bram_disable, brom_disable, page, rampage_lock, sysboot_lock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h, bram_disable=%b, brom_disable=%b, page=%h, rampage_lock=%b, sysboot_lock=%b",
                         expected_DO, expected_bram_disable, expected_brom_disable, expected_page, expected_rampage_lock, expected_sysboot_lock);
                $display("  Got:      DO=%h, bram_disable=%b, brom_disable=%b, page=%h, rampage_lock=%b, sysboot_lock=%b",
                         DO, bram_disable, brom_disable, page, rampage_lock, sysboot_lock);
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
        $dumpvars(0,AD, DI, clk, cs, rst, rw, DO, bram_disable, brom_disable, page, rampage_lock, sysboot_lock);
    end

endmodule
