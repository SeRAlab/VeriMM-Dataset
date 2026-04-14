`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg timer2;
    reg wb_cyc_i;
    reg [7:0] wb_dat_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire speaker_;
    wire wb_ack_o;
    wire [7:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .timer2(timer2),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .speaker_(speaker_),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i = 0;
        wb_dat_i = 8'h00;
        timer2 = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset state check...");
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Enable speaker and toggle timer...");
        reset_dut();


        @(posedge clk);
        wb_cyc_i = 1;
        wb_stb_i = 1;
        wb_we_i = 1;
        wb_dat_i = 8'h02;

        @(posedge clk);
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i = 0;


        timer2 = 1;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b0, 8'h02);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Speaker off when timer is low...");
        reset_dut();


        @(posedge clk);
        wb_cyc_i = 1;
        wb_stb_i = 1;
        wb_we_i = 1;
        wb_dat_i = 8'h02;

        @(posedge clk);
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i = 0;


        timer2 = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 8'h02);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Speaker off when register bit is clear...");
        reset_dut();


        @(posedge clk);
        wb_cyc_i = 1;
        wb_stb_i = 1;
        wb_we_i = 1;
        wb_dat_i = 8'hFD;

        @(posedge clk);
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i = 0;


        timer2 = 1;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 8'hFD);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Wishbone handshake and data update...");
        reset_dut();

        @(posedge clk);
        wb_cyc_i = 1;
        wb_stb_i = 1;
        wb_we_i = 1;
        wb_dat_i = 8'hAA;


        #1;
        if (wb_ack_o !== 1'b1) begin
            $display("FAIL: wb_ack_o not asserted during active strobe/cycle");
        end

        @(posedge clk);

        wb_stb_i = 0;


        repeat(1) @(posedge clk);
        timer2 = 1;
        #1;


        #1;



        check_outputs(1'b1, 1'b0, 8'hAA);
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
        input expected_speaker_;
        input expected_wb_ack_o;
        input [7:0] expected_wb_dat_o;
        begin
            if (expected_speaker_ === (expected_speaker_ ^ speaker_ ^ expected_speaker_) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: speaker_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         speaker_, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speaker_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_speaker_, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      speaker_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         speaker_, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,clk, rst, timer2, wb_cyc_i, wb_dat_i, wb_stb_i, wb_we_i, speaker_, wb_ack_o, wb_dat_o);
    end

endmodule
