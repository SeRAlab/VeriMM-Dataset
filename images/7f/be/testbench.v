`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I1;
    reg I2;
    reg [8:0] RD_PNTR_WR;
    reg rst_d2;
    reg rst_full_gen_i;
    reg wr_clk;
    reg wr_en;
    wire O1;
    wire [8:0] O2;
    wire Q;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .I2(I2),
        .RD_PNTR_WR(RD_PNTR_WR),
        .rst_d2(rst_d2),
        .rst_full_gen_i(rst_full_gen_i),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .O1(O1),
        .O2(O2),
        .Q(Q),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        rst_d2 = 0;
        forever #5 rst_d2 = ~rst_d2;
    end

        task reset_dut;

        begin
            wr_clk = 0;
            wr_en = 0;
            rst_d2 = 1;
            rst_full_gen_i = 1;
            I1 = 0;
            I2 = 0;
            RD_PNTR_WR = 9'h000;
            #20;
            rst_d2 = 0;
            rst_full_gen_i = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 9'h000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            wr_en = 1;
            I1 = 1;
            #5 wr_clk = 1; #5 wr_clk = 0;
            wr_en = 0;
            #10;



            #1;




            check_outputs(1'b0, 9'h001, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            wr_en = 1;
            I1 = 1; I2 = 0; #5 wr_clk = 1; #5 wr_clk = 0;
            I1 = 0; I2 = 1; #5 wr_clk = 1; #5 wr_clk = 0;
            I1 = 1; I2 = 1; #5 wr_clk = 1; #5 wr_clk = 0;
            wr_en = 0;
            #10;


            #1;



            check_outputs(1'b0, 9'h003, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            RD_PNTR_WR = 9'h005;


            wr_en = 1;
            for(i=0; i<5; i=i+1) begin
                I1 = 1;
                #5 wr_clk = 1; #5 wr_clk = 0;
            end
            wr_en = 0;
            #10;




            #1;





            check_outputs(1'b0, 9'h005, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            wr_en = 1;
            #5 wr_clk = 1; #5 wr_clk = 0;
            #5 wr_clk = 1; #5 wr_clk = 0;


            rst_d2 = 1;
            #20;
            rst_d2 = 0;
            #10;


            #1;



            check_outputs(1'b0, 9'h000, 1'b0, 1'b0);
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
        input expected_O1;
        input [8:0] expected_O2;
        input expected_Q;
        input expected_full;
        begin
            if (expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: O1=%b, O2=%h, Q=%b, full=%b",
                         O1, O2, Q, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O1=%b, O2=%h, Q=%b, full=%b",
                         expected_O1, expected_O2, expected_Q, expected_full);
                $display("  Got:      O1=%b, O2=%h, Q=%b, full=%b",
                         O1, O2, Q, full);
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
        $dumpvars(0,I1, I2, RD_PNTR_WR, rst_d2, rst_full_gen_i, wr_clk, wr_en, O1, O2, Q, full);
    end

endmodule
