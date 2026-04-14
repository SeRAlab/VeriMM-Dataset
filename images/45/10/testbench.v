`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] gpio_i;
    reg wb_adr_i;
    reg [1:0] wb_bte_i;
    reg wb_clk;
    reg [2:0] wb_cti_i;
    reg wb_cyc_i;
    reg [7:0] wb_dat_i;
    reg wb_rst;
    reg wb_stb_i;
    reg wb_we_i;
    wire [7:0] gpio_dir_o;
    wire [7:0] gpio_o;
    wire wb_ack_o;
    wire [7:0] wb_dat_o;
    wire wb_err_o;
    wire wb_rty_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gpio_i(gpio_i),
        .wb_adr_i(wb_adr_i),
        .wb_bte_i(wb_bte_i),
        .wb_clk(wb_clk),
        .wb_cti_i(wb_cti_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_rst(wb_rst),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .gpio_dir_o(gpio_dir_o),
        .gpio_o(gpio_o),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o),
        .wb_err_o(wb_err_o),
        .wb_rty_o(wb_rty_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk = 0;
        forever #5 wb_clk = ~wb_clk;
    end

        task reset_dut;

        begin
            wb_rst = 1;
            wb_adr_i = 0;
            wb_dat_i = 0;
            wb_we_i = 0;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_cti_i = 0;
            wb_bte_i = 0;
            gpio_i = 8'h00;
            repeat(2) @(posedge wb_clk);
            wb_rst = 0;
            repeat(2) @(posedge wb_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 0, 8'h00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge wb_clk);
            wb_adr_i = 1'b1;
            wb_dat_i = 8'hFF;
            wb_we_i  = 1'b1;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            wait(wb_ack_o);
            @(posedge wb_clk);
            wb_cyc_i = 1'b0;
            wb_stb_i = 1'b0;


            #1;



            check_outputs(8'hFF, 8'h00, 0, 8'h00, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge wb_clk);
            wb_adr_i = 1'b0;
            wb_dat_i = 8'hAA;
            wb_we_i  = 1'b1;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            wait(wb_ack_o);
            @(posedge wb_clk);
            wb_cyc_i = 1'b0;
            wb_stb_i = 1'b0;


            #1;



            check_outputs(8'h00, 8'hAA, 0, 8'h00, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            gpio_i = 8'h55;

            @(posedge wb_clk);
            wb_adr_i = 1'b0;
            wb_we_i  = 1'b0;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            wait(wb_ack_o);

            #1;


            check_outputs(8'h00, 8'h00, 1, 8'h55, 0, 0);

            @(posedge wb_clk);
            wb_cyc_i = 1'b0;
            wb_stb_i = 1'b0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge wb_clk);
            wb_adr_i = 1'b1;
            wb_dat_i = 8'h0F;
            wb_we_i  = 1'b1;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;
            wait(wb_ack_o);
            @(posedge wb_clk);


            wb_we_i  = 1'b0;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;
            wait(wb_ack_o);


            #1;



            check_outputs(8'h0F, 8'h00, 1, 8'h0F, 0, 0);

            @(posedge wb_clk);
            wb_cyc_i = 1'b0;
            wb_stb_i = 1'b0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge wb_clk);
            wb_adr_i = 1'b0;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            wait(wb_ack_o);

            #1;


            check_outputs(8'h00, 8'h00, 1, 8'h00, 0, 0);

            @(posedge wb_clk);
            wb_cyc_i = 1'b0;
            wb_stb_i = 1'b0;
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
        input [7:0] expected_gpio_dir_o;
        input [7:0] expected_gpio_o;
        input expected_wb_ack_o;
        input [7:0] expected_wb_dat_o;
        input expected_wb_err_o;
        input expected_wb_rty_o;
        begin
            if (expected_gpio_dir_o === (expected_gpio_dir_o ^ gpio_dir_o ^ expected_gpio_dir_o) &&
                expected_gpio_o === (expected_gpio_o ^ gpio_o ^ expected_gpio_o) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_wb_err_o === (expected_wb_err_o ^ wb_err_o ^ expected_wb_err_o) &&
                expected_wb_rty_o === (expected_wb_rty_o ^ wb_rty_o ^ expected_wb_rty_o)) begin
                $display("PASS");
                $display("  Outputs: gpio_dir_o=%h, gpio_o=%h, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b, wb_rty_o=%b",
                         gpio_dir_o, gpio_o, wb_ack_o, wb_dat_o, wb_err_o, wb_rty_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_dir_o=%h, gpio_o=%h, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b, wb_rty_o=%b",
                         expected_gpio_dir_o, expected_gpio_o, expected_wb_ack_o, expected_wb_dat_o, expected_wb_err_o, expected_wb_rty_o);
                $display("  Got:      gpio_dir_o=%h, gpio_o=%h, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b, wb_rty_o=%b",
                         gpio_dir_o, gpio_o, wb_ack_o, wb_dat_o, wb_err_o, wb_rty_o);
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
        $dumpvars(0,gpio_i, wb_adr_i, wb_bte_i, wb_clk, wb_cti_i, wb_cyc_i, wb_dat_i, wb_rst, wb_stb_i, wb_we_i, gpio_dir_o, gpio_o, wb_ack_o, wb_dat_o, wb_err_o, wb_rty_o);
    end

endmodule
