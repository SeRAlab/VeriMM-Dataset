`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] tg68_adr;
    reg tg68_as;
    reg [15:0] tg68_dat_out;
    reg tg68_lds;
    reg tg68_rw;
    reg tg68_uds;
    wire [15:0] tg68_dat_in;
    wire tg68_dtack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .tg68_adr(tg68_adr),
        .tg68_as(tg68_as),
        .tg68_dat_out(tg68_dat_out),
        .tg68_lds(tg68_lds),
        .tg68_rw(tg68_rw),
        .tg68_uds(tg68_uds),
        .tg68_dat_in(tg68_dat_in),
        .tg68_dtack(tg68_dtack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        tg68_as      <= 1'b1;
        tg68_lds     <= 1'b1;
        tg68_uds     <= 1'b1;
        tg68_rw      <= 1'b1;
        tg68_adr     <= 32'h0;
        tg68_dat_out <= 16'h0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Full Word Write and Read...");
        reset_dut();
        test_num = test_num + 1;


        tg68_adr     <= 32'h0000_0100;
        tg68_dat_out <= 16'hABCD;
        tg68_rw      <= 1'b0;
        tg68_as      <= 1'b0;
        tg68_uds     <= 1'b0;
        tg68_lds     <= 1'b0;

        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);


        tg68_adr <= 32'h0000_0100;
        tg68_rw  <= 1'b1;
        tg68_as  <= 1'b0;
        tg68_uds <= 1'b0;
        tg68_lds <= 1'b0;

        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        #1;

        check_outputs(16'hABCD, 1'b0);


        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Upper Byte Write and Word Read...");
        reset_dut();
        test_num = test_num + 1;


        tg68_adr     <= 32'h200;
        tg68_dat_out <= 16'h0000;
        tg68_rw <= 1'b0; tg68_as <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0); @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);


        tg68_adr     <= 32'h200;
        tg68_dat_out <= 16'h55FF;
        tg68_rw      <= 1'b0;
        tg68_as      <= 1'b0;
        tg68_uds     <= 1'b0;
        tg68_lds     <= 1'b1;

        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);


        tg68_adr <= 32'h200;
        tg68_rw  <= 1'b1;
        tg68_as <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        #1;

        check_outputs(16'h5500, 1'b0);

        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Lower Byte Write and Word Read...");
        reset_dut();
        test_num = test_num + 1;


        tg68_adr     <= 32'h300;
        tg68_dat_out <= 16'hFFAA;
        tg68_rw      <= 1'b0;
        tg68_as      <= 1'b0;
        tg68_uds     <= 1'b1;
        tg68_lds     <= 1'b0;

        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);


        tg68_adr <= 32'h300;
        tg68_rw  <= 1'b1;
        tg68_as <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0);
        @(posedge clk);

        #1;


        check_outputs(16'h00AA, 1'b0);

        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Boundary Address Access...");
        reset_dut();
        test_num = test_num + 1;


        tg68_adr     <= 32'h0000_03FE;
        tg68_dat_out <= 16'h7890;
        tg68_rw      <= 1'b0;
        tg68_as      <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);

        tg68_adr <= 32'h0000_03FE;
        tg68_rw  <= 1'b1;
        tg68_as <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        #1;

        check_outputs(16'h7890, 1'b0);

        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Interleaved Byte Writes...");
        reset_dut();
        test_num = test_num + 1;


        tg68_adr <= 32'h50; tg68_dat_out <= 16'hFFFF; tg68_rw <= 1'b0;
        tg68_as <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0); @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1; @(posedge clk);


        tg68_adr <= 32'h50; tg68_dat_out <= 16'h0022; tg68_rw <= 1'b0;
        tg68_as <= 1'b0; tg68_uds <= 1'b1; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0); @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1; @(posedge clk);


        tg68_adr <= 32'h50; tg68_dat_out <= 16'h1100; tg68_rw <= 1'b0;
        tg68_as <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b1;
        wait(tg68_dtack == 1'b0); @(posedge clk);
        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1; @(posedge clk);


        tg68_adr <= 32'h50; tg68_rw <= 1'b1;
        tg68_as <= 1'b0; tg68_uds <= 1'b0; tg68_lds <= 1'b0;
        wait(tg68_dtack == 1'b0);
        @(posedge clk);
        #1;

        check_outputs(16'h1122, 1'b0);

        tg68_as <= 1'b1; tg68_uds <= 1'b1; tg68_lds <= 1'b1;
        @(posedge clk);
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
        input [15:0] expected_tg68_dat_in;
        input expected_tg68_dtack;
        begin
            if (expected_tg68_dat_in === (expected_tg68_dat_in ^ tg68_dat_in ^ expected_tg68_dat_in) &&
                expected_tg68_dtack === (expected_tg68_dtack ^ tg68_dtack ^ expected_tg68_dtack)) begin
                $display("PASS");
                $display("  Outputs: tg68_dat_in=%h, tg68_dtack=%b",
                         tg68_dat_in, tg68_dtack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tg68_dat_in=%h, tg68_dtack=%b",
                         expected_tg68_dat_in, expected_tg68_dtack);
                $display("  Got:      tg68_dat_in=%h, tg68_dtack=%b",
                         tg68_dat_in, tg68_dtack);
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
        $dumpvars(0,clk, tg68_adr, tg68_as, tg68_dat_out, tg68_lds, tg68_rw, tg68_uds, tg68_dat_in, tg68_dtack);
    end

endmodule
