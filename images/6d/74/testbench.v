`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [18:0] wb_adr_i;
    reg wb_clk_i;
    reg wb_cyc_i;
    reg [15:0] wb_dat_i;
    reg wb_rst_i;
    reg [1:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire wb_ack_o;
    wire [15:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_adr_i(wb_adr_i),
        .wb_clk_i(wb_clk_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_rst_i(wb_rst_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
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
            wb_adr_i = 0;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i  = 0;
            wb_sel_i = 0;
            wb_dat_i = 0;
            repeat(2) @(posedge wb_clk_i);
            #1 wb_rst_i = 0;
            @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Write and Read Back", test_num);
            reset_dut();


            @(posedge wb_clk_i);
            wb_adr_i = 19'h00010;
            wb_dat_i = 16'hABCD;
            wb_we_i  = 1;
            wb_sel_i = 2'b11;
            wb_stb_i = 1;
            wb_cyc_i = 1;


            do @(posedge wb_clk_i); while (!wb_ack_o);


            wb_stb_i = 0;
            wb_cyc_i = 0;
            @(posedge wb_clk_i);


            wb_adr_i = 19'h00010;
            wb_we_i  = 0;
            wb_stb_i = 1;
            wb_cyc_i = 1;

            do @(posedge wb_clk_i); while (!wb_ack_o);


            #1;



            check_outputs(1'b1, 16'hABCD);

            wb_stb_i = 0;
            wb_cyc_i = 0;
            @(posedge wb_clk_i);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying Address Independence", test_num);
            reset_dut();


            @(posedge wb_clk_i);
            wb_adr_i = 19'h00001; wb_dat_i = 16'h1111; wb_we_i = 1; wb_sel_i = 2'b11; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);
            wb_stb_i = 0; wb_cyc_i = 0;


            @(posedge wb_clk_i);
            wb_adr_i = 19'h00002; wb_dat_i = 16'h2222; wb_we_i = 1; wb_sel_i = 2'b11; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);
            wb_stb_i = 0; wb_cyc_i = 0;


            @(posedge wb_clk_i);
            wb_adr_i = 19'h00001; wb_we_i = 0; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);

            #1;


            check_outputs(1'b1, 16'h1111);

            wb_stb_i = 0; wb_cyc_i = 0;
            @(posedge wb_clk_i);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Byte Select Logic Check (MSB)", test_num);
            reset_dut();


            @(posedge wb_clk_i);
            wb_adr_i = 19'h00005; wb_dat_i = 16'h0000; wb_we_i = 1; wb_sel_i = 2'b11; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);
            wb_stb_i = 0; wb_cyc_i = 0;


            @(posedge wb_clk_i);
            wb_adr_i = 19'h00005; wb_dat_i = 16'h77FF; wb_we_i = 1; wb_sel_i = 2'b10; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);
            wb_stb_i = 0; wb_cyc_i = 0;


            @(posedge wb_clk_i);
            wb_adr_i = 19'h00005; wb_we_i = 0; wb_sel_i = 2'b11; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);

            #1;


            check_outputs(1'b1, 16'h7700);

            wb_stb_i = 0; wb_cyc_i = 0;
            @(posedge wb_clk_i);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Byte Select Logic Check (LSB)", test_num);
            reset_dut();


            @(posedge wb_clk_i);
            wb_adr_i = 19'h0000A; wb_dat_i = 16'hFFFF; wb_we_i = 1; wb_sel_i = 2'b11; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);
            wb_stb_i = 0; wb_cyc_i = 0;


            @(posedge wb_clk_i);
            wb_adr_i = 19'h0000A; wb_dat_i = 16'h1200; wb_we_i = 1; wb_sel_i = 2'b01; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);
            wb_stb_i = 0; wb_cyc_i = 0;


            @(posedge wb_clk_i);
            wb_adr_i = 19'h0000A; wb_we_i = 0; wb_sel_i = 2'b11; wb_stb_i = 1; wb_cyc_i = 1;
            do @(posedge wb_clk_i); while (!wb_ack_o);

            #1;


            check_outputs(1'b1, 16'hFF00);

            wb_stb_i = 0; wb_cyc_i = 0;
            @(posedge wb_clk_i);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inactive Bus Cycle Check", test_num);
            reset_dut();


            @(posedge wb_clk_i);
            wb_adr_i = 19'h000FF; wb_dat_i = 16'h5555; wb_we_i = 1; wb_sel_i = 2'b11;
            wb_stb_i = 0; wb_cyc_i = 1;

            repeat(3) @(posedge wb_clk_i);


            #1;



            check_outputs(1'b0, 16'hzzzz);

            wb_cyc_i = 0;
            @(posedge wb_clk_i);
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
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: wb_ack_o=%b, wb_dat_o=%h",
                         wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_ack_o=%b, wb_dat_o=%h",
                         expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      wb_ack_o=%b, wb_dat_o=%h",
                         wb_ack_o, wb_dat_o);
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
        $dumpvars(0,wb_adr_i, wb_clk_i, wb_cyc_i, wb_dat_i, wb_rst_i, wb_sel_i, wb_stb_i, wb_we_i, wb_ack_o, wb_dat_o);
    end

endmodule
