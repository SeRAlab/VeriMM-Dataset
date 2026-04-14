`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pb_;
    reg [7:0] sw_;
    reg tick;
    reg wb_adr_i;
    reg wb_clk_i;
    reg wb_cyc_i;
    reg [15:0] wb_dat_i;
    reg wb_rst_i;
    reg [1:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [13:0] leds_;
    wire nmi_pb;
    wire wb_ack_o;
    wire [15:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pb_(pb_),
        .sw_(sw_),
        .tick(tick),
        .wb_adr_i(wb_adr_i),
        .wb_clk_i(wb_clk_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_rst_i(wb_rst_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .leds_(leds_),
        .nmi_pb(nmi_pb),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            pb_ = 1;
            sw_ = 8'h00;
            tick = 0;
            wb_adr_i = 0;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            wb_dat_i = 0;
            wb_sel_i = 2'b11;
            repeat(5) @(posedge wb_clk_i);
            wb_rst_i = 0;
            @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Write 14-bit data to LEDs");


            wb_adr_i = 0;
            wb_dat_i = 16'h2AAA;
            wb_we_i  = 1;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_sel_i = 2'b11;


            wait(wb_ack_o == 1);
            @(posedge wb_clk_i);


            wb_cyc_i = 0;
            wb_stb_i = 0;


            #1;



            check_outputs(14'h2AAA, 0, 0, 16'hxxxx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Read 8-bit Switch state");

            sw_ = 8'hA5;


            wb_adr_i = 0;
            wb_we_i  = 0;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_sel_i = 2'b11;


            wait(wb_ack_o == 1);



            #1;




            check_outputs(14'h0000, 0, 1, 16'h00A5);

            @(posedge wb_clk_i);
            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: NMI Button Debounce Mechanism");


            pb_ = 0;



            repeat(10) begin
                tick = 1;
                @(posedge wb_clk_i);
                tick = 0;
                repeat(5) @(posedge wb_clk_i);
            end


            #1;



            check_outputs(14'h0000, 1, 0, 16'hxxxx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Mixed write and reset verification");


            wb_adr_i = 0;
            wb_dat_i = 16'h3FFF;
            wb_we_i  = 1;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wait(wb_ack_o == 1);
            @(posedge wb_clk_i);
            wb_cyc_i = 0;
            wb_stb_i = 0;


            wb_rst_i = 1;
            repeat(2) @(posedge wb_clk_i);
            wb_rst_i = 0;
            @(posedge wb_clk_i);


            #1;



            check_outputs(14'h0000, 0, 0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Write with different data pattern");


            sw_ = 8'hFF;


            wb_adr_i = 0;
            wb_dat_i = 16'h1555;
            wb_we_i  = 1;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wait(wb_ack_o == 1);
            @(posedge wb_clk_i);
            wb_cyc_i = 0;
            wb_stb_i = 0;


            #1;



            check_outputs(14'h1555, 0, 0, 16'hxxxx);
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
        input [13:0] expected_leds_;
        input expected_nmi_pb;
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_leds_ === (expected_leds_ ^ leds_ ^ expected_leds_) &&
                expected_nmi_pb === (expected_nmi_pb ^ nmi_pb ^ expected_nmi_pb) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: leds_=%h, nmi_pb=%b, wb_ack_o=%b, wb_dat_o=%h",
                         leds_, nmi_pb, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds_=%h, nmi_pb=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_leds_, expected_nmi_pb, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      leds_=%h, nmi_pb=%b, wb_ack_o=%b, wb_dat_o=%h",
                         leds_, nmi_pb, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,pb_, sw_, tick, wb_adr_i, wb_clk_i, wb_cyc_i, wb_dat_i, wb_rst_i, wb_sel_i, wb_stb_i, wb_we_i, leds_, nmi_pb, wb_ack_o, wb_dat_o);
    end

endmodule
