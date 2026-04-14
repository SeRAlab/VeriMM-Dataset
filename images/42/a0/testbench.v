`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg fifo_rxf;
    reg fifo_txe;
    reg pia_ca2;
    reg pia_cb2;
    reg pia_e;
    reg [6:0] pia_pb;
    reg reset;
    wire fifo_rd;
    wire fifo_wr;
    wire pia_ca1;
    wire pia_cb1;
    wire pia_da;
    wire [6:0] pia_pa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .fifo_rxf(fifo_rxf),
        .fifo_txe(fifo_txe),
        .pia_ca2(pia_ca2),
        .pia_cb2(pia_cb2),
        .pia_e(pia_e),
        .pia_pb(pia_pb),
        .reset(reset),
        .fifo_rd(fifo_rd),
        .fifo_wr(fifo_wr),
        .pia_ca1(pia_ca1),
        .pia_cb1(pia_cb1),
        .pia_da(pia_da),
        .pia_pa(pia_pa)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 1;
            clk = 0;
            pia_e = 0;
            pia_ca2 = 0;
            pia_cb2 = 0;
            pia_pb = 7'b0;
            fifo_rxf = 1;
            fifo_txe = 1;
            #20;
            reset = 0;
            clear = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Read Cycle Start", test_num);
            reset_dut();

            @(posedge clk);
            fifo_rxf = 0;
            pia_e = 1;

            repeat(4) @(posedge clk);




            #1;





            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 7'b0000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Write Cycle Start", test_num);
            reset_dut();

            @(posedge clk);
            fifo_txe = 0;
            pia_cb2 = 1;
            pia_pb = 7'h5A;
            pia_e = 1;

            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 7'b0000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Full / Write Wait", test_num);
            reset_dut();

            @(posedge clk);
            fifo_txe = 1;
            pia_cb2 = 1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 7'b0000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clear Signal Priority", test_num);
            reset_dut();

            @(posedge clk);
            fifo_rxf = 0;
            repeat(2) @(posedge clk);
            clear = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 7'b0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: PIA Port A Output Check", test_num);
            reset_dut();



            @(posedge clk);
            pia_ca2 = 1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 7'h00);
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
        input expected_fifo_rd;
        input expected_fifo_wr;
        input expected_pia_ca1;
        input expected_pia_cb1;
        input expected_pia_da;
        input [6:0] expected_pia_pa;
        begin
            if (expected_fifo_rd === (expected_fifo_rd ^ fifo_rd ^ expected_fifo_rd) &&
                expected_fifo_wr === (expected_fifo_wr ^ fifo_wr ^ expected_fifo_wr) &&
                expected_pia_ca1 === (expected_pia_ca1 ^ pia_ca1 ^ expected_pia_ca1) &&
                expected_pia_cb1 === (expected_pia_cb1 ^ pia_cb1 ^ expected_pia_cb1) &&
                expected_pia_da === (expected_pia_da ^ pia_da ^ expected_pia_da) &&
                expected_pia_pa === (expected_pia_pa ^ pia_pa ^ expected_pia_pa)) begin
                $display("PASS");
                $display("  Outputs: fifo_rd=%b, fifo_wr=%b, pia_ca1=%b, pia_cb1=%b, pia_da=%b, pia_pa=%h",
                         fifo_rd, fifo_wr, pia_ca1, pia_cb1, pia_da, pia_pa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_rd=%b, fifo_wr=%b, pia_ca1=%b, pia_cb1=%b, pia_da=%b, pia_pa=%h",
                         expected_fifo_rd, expected_fifo_wr, expected_pia_ca1, expected_pia_cb1, expected_pia_da, expected_pia_pa);
                $display("  Got:      fifo_rd=%b, fifo_wr=%b, pia_ca1=%b, pia_cb1=%b, pia_da=%b, pia_pa=%h",
                         fifo_rd, fifo_wr, pia_ca1, pia_cb1, pia_da, pia_pa);
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
        $dumpvars(0,clear, clk, fifo_rxf, fifo_txe, pia_ca2, pia_cb2, pia_e, pia_pb, reset, fifo_rd, fifo_wr, pia_ca1, pia_cb1, pia_da, pia_pa);
    end

endmodule
