`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [151:0] din;
    reg rclk;
    reg [4:0] rd_adr;
    reg rd_en;
    reg reset_l;
    reg rst_tri_en;
    reg se;
    reg sehold;
    reg si;
    reg [4:0] wr_adr;
    reg wr_en;
    wire [151:0] dout;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .rclk(rclk),
        .rd_adr(rd_adr),
        .rd_en(rd_en),
        .reset_l(reset_l),
        .rst_tri_en(rst_tri_en),
        .se(se),
        .sehold(sehold),
        .si(si),
        .wr_adr(wr_adr),
        .wr_en(wr_en),
        .dout(dout),
        .so(so)
    );

        task reset_dut;

        begin
            reset_l = 0;
            rst_tri_en = 0;
            se = 0;
            sehold = 0;
            si = 0;
            wr_en = 0;
            rd_en = 0;
            wr_adr = 0;
            rd_adr = 0;
            din = 0;
            @(posedge rclk);
            #2 reset_l = 1;
            @(posedge rclk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Address 0");
            reset_dut();
            @(posedge rclk);
            wr_en = 1;
            wr_adr = 5'h00;
            din = 152'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5;
            @(posedge rclk);
            wr_en = 0;
            rd_en = 1;
            rd_adr = 5'h00;
            @(posedge rclk);
            #2;
            #1;

            check_outputs(152'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Boundary Test - Write and Read at Address 31");
            reset_dut();
            @(posedge rclk);
            wr_en = 1;
            wr_adr = 5'h1F;
            din = 152'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            @(posedge rclk);
            wr_en = 0;
            rd_en = 1;
            rd_adr = 5'h1F;
            @(posedge rclk);
            #2;
            #1;

            check_outputs(152'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Logic Verification (Write while wr_en=0)");
            reset_dut();
            @(posedge rclk);
            wr_en = 0;
            wr_adr = 5'h05;
            din = 152'hCAFECAFE_CAFECAFE_CAFECAFE_CAFECAFE_CAFECAFE;
            @(posedge rclk);
            rd_en = 1;
            rd_adr = 5'h05;
            @(posedge rclk);
            #2;

            #1;


            check_outputs(152'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Read Enable Logic Verification (Read while rd_en=0)");
            reset_dut();

            @(posedge rclk);
            wr_en = 1;
            wr_adr = 5'h0A;
            din = 152'h12345678_9ABCDEF0_12345678_9ABCDEF0_12345678;
            @(posedge rclk);
            wr_en = 0;
            rd_en = 0;
            rd_adr = 5'h0A;
            @(posedge rclk);
            #2;

            #1;


            check_outputs(152'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Dual-Port Operation (Simultaneous Read/Write)");
            reset_dut();

            @(posedge rclk);
            wr_en = 1;
            wr_adr = 5'h01;
            din = 152'hBBBBBBBB_BBBBBBBB_BBBBBBBB_BBBBBBBB_BBBBBBBB;
            @(posedge rclk);

            wr_adr = 5'h02;
            din = 152'hCCCCCCCC_CCCCCCCC_CCCCCCCC_CCCCCCCC_CCCCCCCC;
            rd_en = 1;
            rd_adr = 5'h01;
            @(posedge rclk);
            #2;
            #1;

            check_outputs(152'hBBBBBBBB_BBBBBBBB_BBBBBBBB_BBBBBBBB_BBBBBBBB, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Functionality check");
            reset_dut();
            @(posedge rclk);
            wr_en = 1;
            wr_adr = 5'h03;
            din = 152'hDEDEDEDE_DEDEDEDE_DEDEDEDE_DEDEDEDE_DEDEDEDE;
            @(posedge rclk);
            reset_l = 0;
            @(posedge rclk);
            #2;

            #1;


            check_outputs(152'h0, 1'b0);
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
        input [151:0] expected_dout;
        input expected_so;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, so=%b",
                         dout, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, so=%b",
                         expected_dout, expected_so);
                $display("  Got:      dout=%h, so=%b",
                         dout, so);
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
        $dumpvars(0,din, rclk, rd_adr, rd_en, reset_l, rst_tri_en, se, sehold, si, wr_adr, wr_en, dout, so);
    end

endmodule
