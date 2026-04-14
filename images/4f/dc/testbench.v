`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] csr_di;
    reg sys_clk;
    reg sys_rst;
    reg [2:0] wb_adr_i;
    reg wb_cyc_i;
    reg [15:0] wb_dat_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [2:0] csr_a;
    wire [15:0] csr_do;
    wire csr_we;
    wire wb_ack_o;
    wire [15:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .csr_di(csr_di),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .wb_adr_i(wb_adr_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .csr_a(csr_a),
        .csr_do(csr_do),
        .csr_we(csr_we),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            wb_adr_i = 0;
            wb_dat_i = 0;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            csr_di = 0;
            @(posedge sys_clk);
            #2 sys_rst = 0;
            @(posedge sys_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Idle State Check", test_num);

            #1;


            check_outputs(3'b000, 16'h0000, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Wishbone Write Operation", test_num);

            wb_adr_i = 3'h3;
            wb_dat_i = 16'hABCD;
            wb_we_i = 1;
            wb_cyc_i = 1;
            wb_stb_i = 1;


            wait(wb_ack_o == 1);
            #1;

            #1;


            check_outputs(3'h3, 16'hABCD, 1'b1, 1'b1, wb_dat_o);

            @(posedge sys_clk);
            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Wishbone Read Operation", test_num);

            csr_di = 16'h55AA;
            wb_adr_i = 3'h7;
            wb_we_i = 0;
            wb_cyc_i = 1;
            wb_stb_i = 1;

            wait(wb_ack_o == 1);
            #1;

            #1;


            check_outputs(3'h7, csr_do, 1'b0, 1'b1, 16'h55AA);

            @(posedge sys_clk);
            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Write Operation (Boundary Value 0xFFFF)", test_num);

            wb_adr_i = 3'h0;
            wb_dat_i = 16'hFFFF;
            wb_we_i = 1;
            wb_cyc_i = 1;
            wb_stb_i = 1;

            wait(wb_ack_o == 1);
            #1;
            #1;

            check_outputs(3'h0, 16'hFFFF, 1'b1, 1'b1, wb_dat_o);

            @(posedge sys_clk);
            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Strobe without Cycle (Should be ignored)", test_num);

            wb_adr_i = 3'h4;
            wb_dat_i = 16'h1234;
            wb_we_i = 1;
            wb_cyc_i = 0;
            wb_stb_i = 1;

            repeat(3) @(posedge sys_clk);
            #1;

            #1;


            check_outputs(csr_a, csr_do, 1'b0, 1'b0, wb_dat_o);
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
        input [2:0] expected_csr_a;
        input [15:0] expected_csr_do;
        input expected_csr_we;
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_csr_a === (expected_csr_a ^ csr_a ^ expected_csr_a) &&
                expected_csr_do === (expected_csr_do ^ csr_do ^ expected_csr_do) &&
                expected_csr_we === (expected_csr_we ^ csr_we ^ expected_csr_we) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: csr_a=%h, csr_do=%h, csr_we=%b, wb_ack_o=%b, wb_dat_o=%h",
                         csr_a, csr_do, csr_we, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: csr_a=%h, csr_do=%h, csr_we=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_csr_a, expected_csr_do, expected_csr_we, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      csr_a=%h, csr_do=%h, csr_we=%b, wb_ack_o=%b, wb_dat_o=%h",
                         csr_a, csr_do, csr_we, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,csr_di, sys_clk, sys_rst, wb_adr_i, wb_cyc_i, wb_dat_i, wb_stb_i, wb_we_i, csr_a, csr_do, csr_we, wb_ack_o, wb_dat_o);
    end

endmodule
