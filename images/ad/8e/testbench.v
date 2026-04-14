`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ad_ack_i;
    reg [7:0] ad_dat_i;
    reg [7:0] cpu_adr_i;
    reg cpu_cyc_i;
    reg [7:0] cpu_dat_i;
    reg cpu_stb_i;
    reg cpu_we_i;
    reg rs2_ack_i;
    reg [7:0] rs2_dat_i;
    reg t16_ack_i;
    reg [7:0] t16_dat_i;
    reg tmr_ack_i;
    reg [7:0] tmr_dat_i;
    reg wb_clk_i;
    reg wb_rst_i;
    wire ad_adr_o;
    wire [7:0] ad_dat_o;
    wire ad_stb_o;
    wire ad_we_o;
    wire cpu_ack_o;
    wire [7:0] cpu_dat_o;
    wire rs2_adr_o;
    wire [7:0] rs2_dat_o;
    wire rs2_stb_o;
    wire rs2_we_o;
    wire t16_adr_o;
    wire [7:0] t16_dat_o;
    wire t16_stb_o;
    wire t16_we_o;
    wire [2:0] tmr_adr_o;
    wire [7:0] tmr_dat_o;
    wire tmr_stb_o;
    wire tmr_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ad_ack_i(ad_ack_i),
        .ad_dat_i(ad_dat_i),
        .cpu_adr_i(cpu_adr_i),
        .cpu_cyc_i(cpu_cyc_i),
        .cpu_dat_i(cpu_dat_i),
        .cpu_stb_i(cpu_stb_i),
        .cpu_we_i(cpu_we_i),
        .rs2_ack_i(rs2_ack_i),
        .rs2_dat_i(rs2_dat_i),
        .t16_ack_i(t16_ack_i),
        .t16_dat_i(t16_dat_i),
        .tmr_ack_i(tmr_ack_i),
        .tmr_dat_i(tmr_dat_i),
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .ad_adr_o(ad_adr_o),
        .ad_dat_o(ad_dat_o),
        .ad_stb_o(ad_stb_o),
        .ad_we_o(ad_we_o),
        .cpu_ack_o(cpu_ack_o),
        .cpu_dat_o(cpu_dat_o),
        .rs2_adr_o(rs2_adr_o),
        .rs2_dat_o(rs2_dat_o),
        .rs2_stb_o(rs2_stb_o),
        .rs2_we_o(rs2_we_o),
        .t16_adr_o(t16_adr_o),
        .t16_dat_o(t16_dat_o),
        .t16_stb_o(t16_stb_o),
        .t16_we_o(t16_we_o),
        .tmr_adr_o(tmr_adr_o),
        .tmr_dat_o(tmr_dat_o),
        .tmr_stb_o(tmr_stb_o),
        .tmr_we_o(tmr_we_o)
    );
    task clear_inputs;

        begin
            cpu_adr_i = 0; cpu_dat_i = 0; cpu_we_i = 0; cpu_cyc_i = 0; cpu_stb_i = 0;
            ad_ack_i = 0; ad_dat_i = 0; rs2_ack_i = 0; rs2_dat_i = 0;
            t16_ack_i = 0; t16_dat_i = 0; tmr_ack_i = 0; tmr_dat_i = 0;
        end
        endtask

    task cycle;

        begin
            wb_clk_i = 1; #5; wb_clk_i = 0; #5;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            wb_rst_i = 1;
            clear_inputs();
            cycle();
            wb_rst_i = 0;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 0, 8'h00, 0, 8'h00, 0, 0, 0, 8'h00, 0, 0, 3'h0, 8'h00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h00; cpu_dat_i = 8'h55; cpu_we_i = 1; cpu_cyc_i = 1; cpu_stb_i = 1;
            rs2_ack_i = 1;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 1, 8'h00, 0, 8'h55, 1, 1, 0, 8'h00, 0, 0, 3'h0, 8'h00, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h01; cpu_we_i = 0; cpu_cyc_i = 1; cpu_stb_i = 1;
            rs2_ack_i = 1; rs2_dat_i = 8'hAA;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 1, 8'hAA, 1, 8'h00, 1, 0, 0, 8'h00, 0, 0, 3'h0, 8'h00, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h10; cpu_dat_i = 8'h33; cpu_we_i = 1; cpu_cyc_i = 1; cpu_stb_i = 1;
            ad_ack_i = 1;
            cycle();

            #1;


            check_outputs(0, 8'h33, 1, 1, 1, 8'h00, 0, 8'h00, 0, 0, 0, 8'h00, 0, 0, 3'h0, 8'h00, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h11; cpu_we_i = 0; cpu_cyc_i = 1; cpu_stb_i = 1;
            ad_ack_i = 1; ad_dat_i = 8'h44;
            cycle();

            #1;


            check_outputs(1, 8'h00, 1, 0, 1, 8'h44, 0, 8'h00, 0, 0, 0, 8'h00, 0, 0, 3'h0, 8'h00, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h20; cpu_dat_i = 8'h77; cpu_we_i = 1; cpu_cyc_i = 1; cpu_stb_i = 1;
            tmr_ack_i = 1;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 1, 8'h00, 0, 8'h00, 0, 0, 0, 8'h00, 0, 0, 3'h0, 8'h77, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h27; cpu_dat_i = 8'h88; cpu_we_i = 1; cpu_cyc_i = 1; cpu_stb_i = 1;
            tmr_ack_i = 1;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 1, 8'h00, 0, 8'h00, 0, 0, 0, 8'h00, 0, 0, 3'h7, 8'h88, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h30; cpu_dat_i = 8'h99; cpu_we_i = 1; cpu_cyc_i = 1; cpu_stb_i = 1;
            t16_ack_i = 1;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 1, 8'h00, 0, 8'h00, 0, 0, 0, 8'h99, 1, 1, 3'h0, 8'h00, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h31; cpu_we_i = 0; cpu_cyc_i = 1; cpu_stb_i = 1;
            t16_ack_i = 1; t16_dat_i = 8'hEE;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 1, 8'hEE, 0, 8'h00, 0, 0, 1, 8'h00, 1, 0, 3'h0, 8'h00, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            wb_rst_i = 1; cycle(); wb_rst_i = 0; clear_inputs();
            cpu_adr_i = 8'h00; cpu_cyc_i = 1; cpu_stb_i = 0;
            cycle();

            #1;


            check_outputs(0, 8'h00, 0, 0, 0, 8'h00, 0, 8'h00, 0, 0, 0, 8'h00, 0, 0, 3'h0, 8'h00, 0, 0);
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
        testcase010();
        
        
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
        input expected_ad_adr_o;
        input [7:0] expected_ad_dat_o;
        input expected_ad_stb_o;
        input expected_ad_we_o;
        input expected_cpu_ack_o;
        input [7:0] expected_cpu_dat_o;
        input expected_rs2_adr_o;
        input [7:0] expected_rs2_dat_o;
        input expected_rs2_stb_o;
        input expected_rs2_we_o;
        input expected_t16_adr_o;
        input [7:0] expected_t16_dat_o;
        input expected_t16_stb_o;
        input expected_t16_we_o;
        input [2:0] expected_tmr_adr_o;
        input [7:0] expected_tmr_dat_o;
        input expected_tmr_stb_o;
        input expected_tmr_we_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ad_adr_o === (expected_ad_adr_o ^ ad_adr_o ^ expected_ad_adr_o) &&
                expected_ad_dat_o === (expected_ad_dat_o ^ ad_dat_o ^ expected_ad_dat_o) &&
                expected_ad_stb_o === (expected_ad_stb_o ^ ad_stb_o ^ expected_ad_stb_o) &&
                expected_ad_we_o === (expected_ad_we_o ^ ad_we_o ^ expected_ad_we_o) &&
                expected_cpu_ack_o === (expected_cpu_ack_o ^ cpu_ack_o ^ expected_cpu_ack_o) &&
                expected_cpu_dat_o === (expected_cpu_dat_o ^ cpu_dat_o ^ expected_cpu_dat_o) &&
                expected_rs2_adr_o === (expected_rs2_adr_o ^ rs2_adr_o ^ expected_rs2_adr_o) &&
                expected_rs2_dat_o === (expected_rs2_dat_o ^ rs2_dat_o ^ expected_rs2_dat_o) &&
                expected_rs2_stb_o === (expected_rs2_stb_o ^ rs2_stb_o ^ expected_rs2_stb_o) &&
                expected_rs2_we_o === (expected_rs2_we_o ^ rs2_we_o ^ expected_rs2_we_o) &&
                expected_t16_adr_o === (expected_t16_adr_o ^ t16_adr_o ^ expected_t16_adr_o) &&
                expected_t16_dat_o === (expected_t16_dat_o ^ t16_dat_o ^ expected_t16_dat_o) &&
                expected_t16_stb_o === (expected_t16_stb_o ^ t16_stb_o ^ expected_t16_stb_o) &&
                expected_t16_we_o === (expected_t16_we_o ^ t16_we_o ^ expected_t16_we_o) &&
                expected_tmr_adr_o === (expected_tmr_adr_o ^ tmr_adr_o ^ expected_tmr_adr_o) &&
                expected_tmr_dat_o === (expected_tmr_dat_o ^ tmr_dat_o ^ expected_tmr_dat_o) &&
                expected_tmr_stb_o === (expected_tmr_stb_o ^ tmr_stb_o ^ expected_tmr_stb_o) &&
                expected_tmr_we_o === (expected_tmr_we_o ^ tmr_we_o ^ expected_tmr_we_o)) begin
                $display("PASS");
                $display("  Outputs: ad_adr_o=%b, ad_dat_o=%h, ad_stb_o=%b, ad_we_o=%b, cpu_ack_o=%b, cpu_dat_o=%h, rs2_adr_o=%b, rs2_dat_o=%h, rs2_stb_o=%b, rs2_we_o=%b, t16_adr_o=%b, t16_dat_o=%h, t16_stb_o=%b, t16_we_o=%b, tmr_adr_o=%h, tmr_dat_o=%h, tmr_stb_o=%b, tmr_we_o=%b",
                         ad_adr_o, ad_dat_o, ad_stb_o, ad_we_o, cpu_ack_o, cpu_dat_o, rs2_adr_o, rs2_dat_o, rs2_stb_o, rs2_we_o, t16_adr_o, t16_dat_o, t16_stb_o, t16_we_o, tmr_adr_o, tmr_dat_o, tmr_stb_o, tmr_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ad_adr_o=%b, ad_dat_o=%h, ad_stb_o=%b, ad_we_o=%b, cpu_ack_o=%b, cpu_dat_o=%h, rs2_adr_o=%b, rs2_dat_o=%h, rs2_stb_o=%b, rs2_we_o=%b, t16_adr_o=%b, t16_dat_o=%h, t16_stb_o=%b, t16_we_o=%b, tmr_adr_o=%h, tmr_dat_o=%h, tmr_stb_o=%b, tmr_we_o=%b",
                         expected_ad_adr_o, expected_ad_dat_o, expected_ad_stb_o, expected_ad_we_o, expected_cpu_ack_o, expected_cpu_dat_o, expected_rs2_adr_o, expected_rs2_dat_o, expected_rs2_stb_o, expected_rs2_we_o, expected_t16_adr_o, expected_t16_dat_o, expected_t16_stb_o, expected_t16_we_o, expected_tmr_adr_o, expected_tmr_dat_o, expected_tmr_stb_o, expected_tmr_we_o);
                $display("  Got:      ad_adr_o=%b, ad_dat_o=%h, ad_stb_o=%b, ad_we_o=%b, cpu_ack_o=%b, cpu_dat_o=%h, rs2_adr_o=%b, rs2_dat_o=%h, rs2_stb_o=%b, rs2_we_o=%b, t16_adr_o=%b, t16_dat_o=%h, t16_stb_o=%b, t16_we_o=%b, tmr_adr_o=%h, tmr_dat_o=%h, tmr_stb_o=%b, tmr_we_o=%b",
                         ad_adr_o, ad_dat_o, ad_stb_o, ad_we_o, cpu_ack_o, cpu_dat_o, rs2_adr_o, rs2_dat_o, rs2_stb_o, rs2_we_o, t16_adr_o, t16_dat_o, t16_stb_o, t16_we_o, tmr_adr_o, tmr_dat_o, tmr_stb_o, tmr_we_o);
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

endmodule
