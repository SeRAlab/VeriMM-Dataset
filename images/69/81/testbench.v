`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg go;
    reg [7:0] len;
    reg lsb;
    reg neg_edge;
    reg [17:0] p_in;
    reg pos_edge;
    reg rst;
    reg rx_negedge;
    reg s_clk;
    reg tx_negedge;
    wire last;
    wire [17:0] p_out;
    wire s_out;
    wire tip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .go(go),
        .len(len),
        .lsb(lsb),
        .neg_edge(neg_edge),
        .p_in(p_in),
        .pos_edge(pos_edge),
        .rst(rst),
        .rx_negedge(rx_negedge),
        .s_clk(s_clk),
        .tx_negedge(tx_negedge),
        .last(last),
        .p_out(p_out),
        .s_out(s_out),
        .tip(tip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            go = 0;
            len = 0;
            lsb = 0;
            neg_edge = 0;
            pos_edge = 0;
            p_in = 0;
            rx_negedge = 0;
            tx_negedge = 1;
            s_clk = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task pulse_spi_cycle;

        begin
            @(posedge clk);
            s_clk = 1;
            pos_edge = 1;
            @(posedge clk);
            pos_edge = 0;
            repeat (2) @(posedge clk);
            s_clk = 0;
            neg_edge = 1;
            @(posedge clk);
            neg_edge = 0;
            repeat (2) @(posedge clk);
        end
        endtask

    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 8-bit MSB first transfer", test_num);
            reset_dut();

            len = 8;
            lsb = 0;
            p_in = 18'h000A5;

            @(posedge clk);
            go = 1;
            @(posedge clk);
            go = 0;


            for (i = 0; i < 8; i = i + 1) begin
                pulse_spi_cycle();
            end





            #1;






            check_outputs(1'b0, 18'h0A500, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 8-bit LSB first transfer", test_num);
            reset_dut();

            len = 8;
            lsb = 1;
            p_in = 18'h000A5;

            @(posedge clk);
            go = 1;
            @(posedge clk);
            go = 0;

            for (i = 0; i < 8; i = i + 1) begin
                pulse_spi_cycle();
            end


            #1;



            check_outputs(1'b0, 18'h000A5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 18-bit MSB first transfer", test_num);
            reset_dut();

            len = 18;
            lsb = 0;
            p_in = 18'h3FFFF;

            @(posedge clk);
            go = 1;
            @(posedge clk);
            go = 0;

            for (i = 0; i < 18; i = i + 1) begin
                pulse_spi_cycle();
            end

            #1;


            check_outputs(1'b0, 18'h3FFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 4-bit MSB first transfer", test_num);
            reset_dut();

            len = 4;
            lsb = 0;
            p_in = 18'h0000F;

            @(posedge clk);
            go = 1;
            @(posedge clk);
            go = 0;

            for (i = 0; i < 4; i = i + 1) begin
                pulse_spi_cycle();
            end

            #1;


            check_outputs(1'b0, 18'h000F0, 1'b1, 1'b0);
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
        input expected_last;
        input [17:0] expected_p_out;
        input expected_s_out;
        input expected_tip;
        begin
            if (expected_last === (expected_last ^ last ^ expected_last) &&
                expected_p_out === (expected_p_out ^ p_out ^ expected_p_out) &&
                expected_s_out === (expected_s_out ^ s_out ^ expected_s_out) &&
                expected_tip === (expected_tip ^ tip ^ expected_tip)) begin
                $display("PASS");
                $display("  Outputs: last=%b, p_out=%h, s_out=%b, tip=%b",
                         last, p_out, s_out, tip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: last=%b, p_out=%h, s_out=%b, tip=%b",
                         expected_last, expected_p_out, expected_s_out, expected_tip);
                $display("  Got:      last=%b, p_out=%h, s_out=%b, tip=%b",
                         last, p_out, s_out, tip);
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
        $dumpvars(0,clk, go, len, lsb, neg_edge, p_in, pos_edge, rst, rx_negedge, s_clk, tx_negedge, last, p_out, s_out, tip);
    end

endmodule
