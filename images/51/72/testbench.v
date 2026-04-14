`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] i_m_adr;
    reg i_m_cyc;
    reg [31:0] i_m_dat;
    reg [3:0] i_m_sel;
    reg i_m_stb;
    reg i_m_we;
    reg i_s0_ack;
    reg [31:0] i_s0_dat;
    reg i_s0_int;
    reg rst;
    wire o_m_ack;
    wire [31:0] o_m_dat;
    wire o_m_int;
    wire [31:0] o_s0_adr;
    wire o_s0_cyc;
    wire [31:0] o_s0_dat;
    wire [3:0] o_s0_sel;
    wire o_s0_stb;
    wire o_s0_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_m_adr(i_m_adr),
        .i_m_cyc(i_m_cyc),
        .i_m_dat(i_m_dat),
        .i_m_sel(i_m_sel),
        .i_m_stb(i_m_stb),
        .i_m_we(i_m_we),
        .i_s0_ack(i_s0_ack),
        .i_s0_dat(i_s0_dat),
        .i_s0_int(i_s0_int),
        .rst(rst),
        .o_m_ack(o_m_ack),
        .o_m_dat(o_m_dat),
        .o_m_int(o_m_int),
        .o_s0_adr(o_s0_adr),
        .o_s0_cyc(o_s0_cyc),
        .o_s0_dat(o_s0_dat),
        .o_s0_sel(o_s0_sel),
        .o_s0_stb(o_s0_stb),
        .o_s0_we(o_s0_we)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write Transaction", test_num);
            reset_dut();


            i_m_adr = 32'h0000_1000;
            i_m_dat = 32'hDEADBEEF;
            i_m_we  = 1;
            i_m_sel = 4'hF;
            i_m_cyc = 1;
            i_m_stb = 1;


            @(posedge clk);
            #1;
            i_s0_ack = 1;


            @(posedge clk);
            #2;

            #1;


            check_outputs(
                1'b1,
                32'h0,
                1'b0,
                32'h0000_1000,
                1'b1,
                32'hDEADBEEF,
                4'hF,
                1'b1,
                1'b1
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Read Transaction", test_num);
            reset_dut();


            i_m_adr = 32'h0000_2000;
            i_m_we  = 0;
            i_m_sel = 4'hF;
            i_m_cyc = 1;
            i_m_stb = 1;


            @(posedge clk);
            #1;
            i_s0_dat = 32'hCAFEBABE;
            i_s0_ack = 1;


            @(posedge clk);
            #2;

            #1;


            check_outputs(
                1'b1,
                32'hCAFEBABE,
                1'b0,
                32'h0000_2000,
                1'b1,
                32'h0,
                4'hF,
                1'b1,
                1'b0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Interrupt Pass-through", test_num);
            reset_dut();


            i_s0_int = 1;


            @(posedge clk);
            #2;

            #1;


            check_outputs(
                1'b0,
                32'h0,
                1'b1,
                32'h0,
                1'b0,
                32'h0,
                4'h0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle State Verification", test_num);
            reset_dut();

            i_m_cyc = 0;
            i_m_stb = 0;
            i_s0_ack = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                1'b0,
                32'h0,
                1'b0,
                32'h0,
                1'b0,
                32'h0,
                4'h0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Partial Selection Write", test_num);
            reset_dut();

            i_m_adr = 32'hABC0_0000;
            i_m_dat = 32'h11223344;
            i_m_we  = 1;
            i_m_sel = 4'b1010;
            i_m_cyc = 1;
            i_m_stb = 1;

            @(posedge clk);
            #1;
            i_s0_ack = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                1'b1,
                32'h0,
                1'b0,
                32'hABC0_0000,
                1'b1,
                32'h11223344,
                4'b1010,
                1'b1,
                1'b1
            );
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
        input expected_o_m_ack;
        input [31:0] expected_o_m_dat;
        input expected_o_m_int;
        input [31:0] expected_o_s0_adr;
        input expected_o_s0_cyc;
        input [31:0] expected_o_s0_dat;
        input [3:0] expected_o_s0_sel;
        input expected_o_s0_stb;
        input expected_o_s0_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_m_ack === (expected_o_m_ack ^ o_m_ack ^ expected_o_m_ack) &&
                expected_o_m_dat === (expected_o_m_dat ^ o_m_dat ^ expected_o_m_dat) &&
                expected_o_m_int === (expected_o_m_int ^ o_m_int ^ expected_o_m_int) &&
                expected_o_s0_adr === (expected_o_s0_adr ^ o_s0_adr ^ expected_o_s0_adr) &&
                expected_o_s0_cyc === (expected_o_s0_cyc ^ o_s0_cyc ^ expected_o_s0_cyc) &&
                expected_o_s0_dat === (expected_o_s0_dat ^ o_s0_dat ^ expected_o_s0_dat) &&
                expected_o_s0_sel === (expected_o_s0_sel ^ o_s0_sel ^ expected_o_s0_sel) &&
                expected_o_s0_stb === (expected_o_s0_stb ^ o_s0_stb ^ expected_o_s0_stb) &&
                expected_o_s0_we === (expected_o_s0_we ^ o_s0_we ^ expected_o_s0_we)) begin
                $display("PASS");
                $display("  Outputs: o_m_ack=%b, o_m_dat=%h, o_m_int=%b, o_s0_adr=%h, o_s0_cyc=%b, o_s0_dat=%h, o_s0_sel=%h, o_s0_stb=%b, o_s0_we=%b",
                         o_m_ack, o_m_dat, o_m_int, o_s0_adr, o_s0_cyc, o_s0_dat, o_s0_sel, o_s0_stb, o_s0_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_m_ack=%b, o_m_dat=%h, o_m_int=%b, o_s0_adr=%h, o_s0_cyc=%b, o_s0_dat=%h, o_s0_sel=%h, o_s0_stb=%b, o_s0_we=%b",
                         expected_o_m_ack, expected_o_m_dat, expected_o_m_int, expected_o_s0_adr, expected_o_s0_cyc, expected_o_s0_dat, expected_o_s0_sel, expected_o_s0_stb, expected_o_s0_we);
                $display("  Got:      o_m_ack=%b, o_m_dat=%h, o_m_int=%b, o_s0_adr=%h, o_s0_cyc=%b, o_s0_dat=%h, o_s0_sel=%h, o_s0_stb=%b, o_s0_we=%b",
                         o_m_ack, o_m_dat, o_m_int, o_s0_adr, o_s0_cyc, o_s0_dat, o_s0_sel, o_s0_stb, o_s0_we);
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
