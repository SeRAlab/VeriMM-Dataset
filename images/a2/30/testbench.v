`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg DIA;
    reg E;
    reg Rst0;
    reg fifo_tx_en;
    reg s_axi_aclk;
    wire [3:0] Q;
    wire out;
    wire txfifo_empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .DIA(DIA),
        .E(E),
        .Rst0(Rst0),
        .fifo_tx_en(fifo_tx_en),
        .s_axi_aclk(s_axi_aclk),
        .Q(Q),
        .out(out),
        .txfifo_empty(txfifo_empty)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            Rst0 = 1;
            E = 0;
            DIA = 0;
            D = 0;
            fifo_tx_en = 0;
            @(posedge s_axi_aclk);
            #1;
            Rst0 = 0;
            @(posedge s_axi_aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write/Read", test_num);
            reset_dut();


            D = 4'h5; E = 1; DIA = 1;
            @(posedge s_axi_aclk); #1;
            E = 0; DIA = 0;
            @(posedge s_axi_aclk); #1;


            fifo_tx_en = 1;
            @(posedge s_axi_aclk); #1;
            fifo_tx_en = 0;
            @(posedge s_axi_aclk); #1;


            #1;



            check_outputs(4'h5, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO (8 entries)", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                D = i; E = 1; DIA = 1;
                @(posedge s_axi_aclk); #1;
            end
            E = 0; DIA = 0;
            @(posedge s_axi_aclk); #1;



            #1;




            check_outputs(4'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill and Empty FIFO", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                D = i; E = 1; DIA = 1;
                @(posedge s_axi_aclk); #1;
            end
            E = 0; DIA = 0;
            @(posedge s_axi_aclk); #1;


            for (i = 0; i < 8; i = i + 1) begin
                fifo_tx_en = 1;
                @(posedge s_axi_aclk); #1;
                fifo_tx_en = 0;
                @(posedge s_axi_aclk); #1;
            end


            #1;



            check_outputs(4'h7, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 'out' signal during write", test_num);
            reset_dut();


            D = 4'hF; E = 1; DIA = 1;
            @(posedge s_axi_aclk);

            #1;


            check_outputs(4'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Integrity Check", test_num);
            reset_dut();


            D = 4'hC; E = 1; DIA = 1; @(posedge s_axi_aclk); #1;
            D = 4'h3; E = 1; DIA = 1; @(posedge s_axi_aclk); #1;
            E = 0; DIA = 0; @(posedge s_axi_aclk); #1;


            fifo_tx_en = 1; @(posedge s_axi_aclk); #1;
            fifo_tx_en = 0; @(posedge s_axi_aclk); #1;


            fifo_tx_en = 1; @(posedge s_axi_aclk); #1;
            fifo_tx_en = 0; @(posedge s_axi_aclk); #1;


            #1;



            check_outputs(4'h3, 1'b1, 1'b1);
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
        input [3:0] expected_Q;
        input expected_out;
        input expected_txfifo_empty;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_txfifo_empty === (expected_txfifo_empty ^ txfifo_empty ^ expected_txfifo_empty)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, out=%b, txfifo_empty=%b",
                         Q, out, txfifo_empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, out=%b, txfifo_empty=%b",
                         expected_Q, expected_out, expected_txfifo_empty);
                $display("  Got:      Q=%h, out=%b, txfifo_empty=%b",
                         Q, out, txfifo_empty);
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
        $dumpvars(0,D, DIA, E, Rst0, fifo_tx_en, s_axi_aclk, Q, out, txfifo_empty);
    end

endmodule
