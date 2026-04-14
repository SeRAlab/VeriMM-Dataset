`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] ADDR;
    reg MIO_EN;
    reg R_W;
    reg clk;
    wire [1:0] INMUX;
    wire LD_DDR;
    wire LD_DSR;
    wire LD_KBSR;
    wire MEM_EN;
    wire R;
    wire RD_KBDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .MIO_EN(MIO_EN),
        .R_W(R_W),
        .clk(clk),
        .INMUX(INMUX),
        .LD_DDR(LD_DDR),
        .LD_DSR(LD_DSR),
        .LD_KBSR(LD_KBSR),
        .MEM_EN(MEM_EN),
        .R(R),
        .RD_KBDR(RD_KBDR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ADDR = 16'h0000;
            MIO_EN = 1'b0;
            R_W = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ADDR = 16'hFE00;
            MIO_EN = 1'b0;
            R_W = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Idle State (MIO_EN=0)", test_num);

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ADDR = 16'hFE00;
            MIO_EN = 1'b1;
            R_W = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Read KBSR (0xFE00)", test_num);

            #1;


            check_outputs(2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ADDR = 16'hFE02;
            MIO_EN = 1'b1;
            R_W = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Read KBDR (0xFE02)", test_num);

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ADDR = 16'hFE00;
            MIO_EN = 1'b1;
            R_W = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write KBSR (0xFE00)", test_num);

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ADDR = 16'hFE04;
            MIO_EN = 1'b1;
            R_W = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Read DSR (0xFE04)", test_num);

            #1;


            check_outputs(2'b11, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ADDR = 16'hFE06;
            MIO_EN = 1'b1;
            R_W = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write DDR (0xFE06)", test_num);

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ADDR = 16'h3000;
            MIO_EN = 1'b1;
            R_W = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Normal Memory Read (0x3000)", test_num);

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            ADDR = 16'h4500;
            MIO_EN = 1'b1;
            R_W = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Normal Memory Write (0x4500)", test_num);

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            ADDR = 16'hFE04;
            MIO_EN = 1'b1;
            R_W = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write DSR (0xFE04)", test_num);

            #1;


            check_outputs(2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
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
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_INMUX;
        input expected_LD_DDR;
        input expected_LD_DSR;
        input expected_LD_KBSR;
        input expected_MEM_EN;
        input expected_R;
        input expected_RD_KBDR;
        begin
            if (expected_INMUX === (expected_INMUX ^ INMUX ^ expected_INMUX) &&
                expected_LD_DDR === (expected_LD_DDR ^ LD_DDR ^ expected_LD_DDR) &&
                expected_LD_DSR === (expected_LD_DSR ^ LD_DSR ^ expected_LD_DSR) &&
                expected_LD_KBSR === (expected_LD_KBSR ^ LD_KBSR ^ expected_LD_KBSR) &&
                expected_MEM_EN === (expected_MEM_EN ^ MEM_EN ^ expected_MEM_EN) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_RD_KBDR === (expected_RD_KBDR ^ RD_KBDR ^ expected_RD_KBDR)) begin
                $display("PASS");
                $display("  Outputs: INMUX=%h, LD_DDR=%b, LD_DSR=%b, LD_KBSR=%b, MEM_EN=%b, R=%b, RD_KBDR=%b",
                         INMUX, LD_DDR, LD_DSR, LD_KBSR, MEM_EN, R, RD_KBDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INMUX=%h, LD_DDR=%b, LD_DSR=%b, LD_KBSR=%b, MEM_EN=%b, R=%b, RD_KBDR=%b",
                         expected_INMUX, expected_LD_DDR, expected_LD_DSR, expected_LD_KBSR, expected_MEM_EN, expected_R, expected_RD_KBDR);
                $display("  Got:      INMUX=%h, LD_DDR=%b, LD_DSR=%b, LD_KBSR=%b, MEM_EN=%b, R=%b, RD_KBDR=%b",
                         INMUX, LD_DDR, LD_DSR, LD_KBSR, MEM_EN, R, RD_KBDR);
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
        $dumpvars(0,ADDR, MIO_EN, R_W, clk, INMUX, LD_DDR, LD_DSR, LD_KBSR, MEM_EN, R, RD_KBDR);
    end

endmodule
