`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] gpio_in;
    reg [35:0] wb_adr_i;
    reg wb_cyc_i;
    reg [31:0] wb_dat_i;
    reg [3:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [31:0] gpio_out;
    wire wb_ack_o;
    wire [31:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gpio_in(gpio_in),
        .wb_adr_i(wb_adr_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .gpio_out(gpio_out),
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
            wb_dat_i = 32'h0;
            wb_adr_i = 36'h0;
            wb_we_i  = 1'b0;
            wb_sel_i = 4'h0;
            wb_stb_i = 1'b0;
            wb_cyc_i = 1'b0;
            gpio_in  = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Simple Write to GPIO Output");

            @(posedge clk);
            wb_dat_i = 32'hAAAA_5555;
            wb_we_i  = 1'b1;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            wb_sel_i = 4'hF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_5555, 1'b1, 32'h0000_0000);


            wb_stb_i = 1'b0;
            wb_cyc_i = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Simple Read from GPIO Input");

            gpio_in = 32'h1234_5678;
            @(posedge clk);
            wb_we_i  = 1'b0;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            wb_sel_i = 4'hF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b1, 32'h1234_5678);

            wb_stb_i = 1'b0;
            wb_cyc_i = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Write ignore when STB is low");


            @(posedge clk);
            wb_dat_i = 32'hFFFF_FFFF;
            wb_we_i  = 1'b1;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            @(posedge clk);


            wb_dat_i = 32'h0000_0000;
            wb_stb_i = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Alternating bit patterns");

            @(posedge clk);
            wb_dat_i = 32'h55AA_55AA;
            wb_we_i  = 1'b1;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA_55AA, 1'b1, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Input capture on rising edge");

            gpio_in = 32'hDEAD_BEEF;
            @(posedge clk);
            wb_we_i  = 1'b0;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1, 32'hDEAD_BEEF);
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
        input [31:0] expected_gpio_out;
        input expected_wb_ack_o;
        input [31:0] expected_wb_dat_o;
        begin
            if (expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: gpio_out=%h, wb_ack_o=%b, wb_dat_o=%h",
                         gpio_out, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_out=%h, wb_ack_o=%b, wb_dat_o=%h",
                         expected_gpio_out, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      gpio_out=%h, wb_ack_o=%b, wb_dat_o=%h",
                         gpio_out, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,clk, gpio_in, wb_adr_i, wb_cyc_i, wb_dat_i, wb_sel_i, wb_stb_i, wb_we_i, gpio_out, wb_ack_o, wb_dat_o);
    end

endmodule
