`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rd_clk;
    reg rd_en;
    reg sys_rst;
    wire [8:0] dout;
    wire empty;
    wire gmii_tx_clk;
    wire gmii_tx_en;
    wire [7:0] gmii_txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .sys_rst(sys_rst),
        .dout(dout),
        .empty(empty),
        .gmii_tx_clk(gmii_tx_clk),
        .gmii_tx_en(gmii_tx_en),
        .gmii_txd(gmii_txd)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            rd_en = 0;
            @(posedge rd_clk);
            @(posedge rd_clk);
            #2 sys_rst = 0;
            @(posedge rd_clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Power-on Reset State", test_num);
            reset_dut();
            @(posedge rd_clk);
            #1;



            #1;




            check_outputs(9'h000, 1'b1, gmii_tx_clk, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Read Enable on Empty FIFO", test_num);
            reset_dut();
            @(posedge rd_clk);
            rd_en = 1;
            repeat(5) @(posedge rd_clk);
            #1;

            #1;


            check_outputs(9'h000, 1'b1, gmii_tx_clk, 1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Read Enable De-assertion", test_num);
            reset_dut();
            rd_en = 1;
            @(posedge rd_clk);
            rd_en = 0;
            repeat(2) @(posedge rd_clk);
            #1;
            #1;

            check_outputs(9'h000, 1'b1, gmii_tx_clk, 1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Sustained Reset", test_num);
            reset_dut();
            sys_rst = 1;
            rd_en = 1;
            repeat(10) @(posedge rd_clk);
            #1;

            #1;


            check_outputs(9'h000, 1'b1, gmii_tx_clk, 1'b0, 8'h00);
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
        input [8:0] expected_dout;
        input expected_empty;
        input expected_gmii_tx_clk;
        input expected_gmii_tx_en;
        input [7:0] expected_gmii_txd;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_gmii_tx_clk === (expected_gmii_tx_clk ^ gmii_tx_clk ^ expected_gmii_tx_clk) &&
                expected_gmii_tx_en === (expected_gmii_tx_en ^ gmii_tx_en ^ expected_gmii_tx_en) &&
                expected_gmii_txd === (expected_gmii_txd ^ gmii_txd ^ expected_gmii_txd)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, gmii_tx_clk=%b, gmii_tx_en=%b, gmii_txd=%h",
                         dout, empty, gmii_tx_clk, gmii_tx_en, gmii_txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, gmii_tx_clk=%b, gmii_tx_en=%b, gmii_txd=%h",
                         expected_dout, expected_empty, expected_gmii_tx_clk, expected_gmii_tx_en, expected_gmii_txd);
                $display("  Got:      dout=%h, empty=%b, gmii_tx_clk=%b, gmii_tx_en=%b, gmii_txd=%h",
                         dout, empty, gmii_tx_clk, gmii_tx_en, gmii_txd);
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
        $dumpvars(0,rd_clk, rd_en, sys_rst, dout, empty, gmii_tx_clk, gmii_tx_en, gmii_txd);
    end

endmodule
