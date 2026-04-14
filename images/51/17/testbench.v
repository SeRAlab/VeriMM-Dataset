`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] Q;
    reg clk;
    reg [8:0] din;
    reg ram_full_fb_i_reg;
    reg tmp_ram_rd_en;
    wire [8:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .clk(clk),
        .din(din),
        .ram_full_fb_i_reg(ram_full_fb_i_reg),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Q = 12'b0;
            din = 9'b0;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Write to address 0x000 and read back.");


            Q = 12'h000;
            din = 9'h1A5;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(9'h1A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Write to high address and verify decoding.");


            Q = 12'hFFF;
            din = 9'h0FF;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(9'h0FF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Verify write is blocked when RAM is full.");


            Q = 12'h123;
            din = 9'h0AA;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 1;
            @(posedge clk);
            #2;


            Q = 12'h123;
            din = 9'h155;
            ram_full_fb_i_reg = 1;
            tmp_ram_rd_en = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(9'h0AA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Verify access is disabled when tmp_ram_rd_en is low.");


            Q = 12'hABC;
            din = 9'h077;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 1;
            @(posedge clk);
            #2;


            Q = 12'hABC;
            din = 9'h1FF;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            @(posedge clk);
            #2;


            tmp_ram_rd_en = 1;
            Q = 12'hABC;
            #2;


            #1;



            check_outputs(9'h077);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Multiple writes to different locations.");

            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 1;


            Q = 12'h001; din = 9'h011; @(posedge clk); #1;

            Q = 12'h002; din = 9'h022; @(posedge clk); #1;

            Q = 12'h003; din = 9'h033; @(posedge clk); #1;


            Q = 12'h002;
            #2;
            #1;

            check_outputs(9'h022);
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
        input [8:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,Q, clk, din, ram_full_fb_i_reg, tmp_ram_rd_en, dout);
    end

endmodule
