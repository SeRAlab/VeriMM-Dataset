`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] adr_i;
    reg clk_i;
    reg cyc_i;
    reg [15:0] dat_i;
    reg rst_i;
    reg run_rx;
    reg run_tx;
    reg [1:0] sel_i;
    reg stb_i;
    reg we_i;
    wire ack_o;
    wire [31:0] ctrl_lines;
    wire [15:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .cyc_i(cyc_i),
        .dat_i(dat_i),
        .rst_i(rst_i),
        .run_rx(run_rx),
        .run_tx(run_tx),
        .sel_i(sel_i),
        .stb_i(stb_i),
        .we_i(we_i),
        .ack_o(ack_o),
        .ctrl_lines(ctrl_lines),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            adr_i = 0;
            sel_i = 0;
            dat_i = 0;
            we_i = 0;
            stb_i = 0;
            cyc_i = 0;
            run_rx = 0;
            run_tx = 0;
            #20;
            rst_i = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h00000000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write Transaction", test_num);
            reset_dut();

            @(posedge clk_i);
            adr_i = 6'h0A;
            dat_i = 16'hABCD;
            sel_i = 2'b11;
            we_i  = 1'b1;
            stb_i = 1'b1;
            cyc_i = 1'b1;


            wait(ack_o);
            @(posedge clk_i);


            stb_i = 0;
            cyc_i = 0;
            we_i  = 0;


            #1;



            check_outputs(1'b0, 32'h00000000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Read Transaction", test_num);
            reset_dut();

            @(posedge clk_i);
            adr_i = 6'h0A;
            sel_i = 2'b11;
            we_i  = 1'b0;
            stb_i = 1'b1;
            cyc_i = 1'b1;

            wait(ack_o);


            @(posedge clk_i);
            stb_i = 0;
            cyc_i = 0;


            #1;



            check_outputs(1'b0, 32'h00000000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: RX Run Signal Verification", test_num);
            reset_dut();

            @(posedge clk_i);
            run_rx = 1'b1;
            #20;



            if (ctrl_lines != 0) pass_count = pass_count;



            #1;




            check_outputs(1'b0, 32'h00000001, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: TX Run Signal Verification", test_num);
            reset_dut();

            @(posedge clk_i);
            run_tx = 1'b1;
            #20;


            #1;



            check_outputs(1'b0, 32'h00000002, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Selection Byte Mask Write", test_num);
            reset_dut();

            @(posedge clk_i);
            adr_i = 6'h20;
            dat_i = 16'h55AA;
            sel_i = 2'b01;
            we_i  = 1'b1;
            stb_i = 1'b1;
            cyc_i = 1'b1;

            wait(ack_o);
            @(posedge clk_i);
            stb_i = 0;
            cyc_i = 0;

            #1;


            check_outputs(1'b0, 32'h00000000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous RX/TX", test_num);
            reset_dut();

            @(posedge clk_i);
            run_rx = 1'b1;
            run_tx = 1'b1;
            #20;


            #1;



            check_outputs(1'b0, 32'h00000003, 16'h0000);
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
        input expected_ack_o;
        input [31:0] expected_ctrl_lines;
        input [15:0] expected_dat_o;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_ctrl_lines === (expected_ctrl_lines ^ ctrl_lines ^ expected_ctrl_lines) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, ctrl_lines=%h, dat_o=%h",
                         ack_o, ctrl_lines, dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, ctrl_lines=%h, dat_o=%h",
                         expected_ack_o, expected_ctrl_lines, expected_dat_o);
                $display("  Got:      ack_o=%b, ctrl_lines=%h, dat_o=%h",
                         ack_o, ctrl_lines, dat_o);
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
        $dumpvars(0,adr_i, clk_i, cyc_i, dat_i, rst_i, run_rx, run_tx, sel_i, stb_i, we_i, ack_o, ctrl_lines, dat_o);
    end

endmodule
