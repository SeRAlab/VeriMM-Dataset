`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Q;
    reg [1:0] S;
    reg [8:0] WR_PNTR_RD;
    reg rd_clk;
    reg [3:0] wr_pntr_bin_reg;
    wire [2:0] rd_data_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .S(S),
        .WR_PNTR_RD(WR_PNTR_RD),
        .rd_clk(rd_clk),
        .wr_pntr_bin_reg(wr_pntr_bin_reg),
        .rd_data_count(rd_data_count)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            Q = 32'h0;
            S = 2'b00;
            WR_PNTR_RD = 9'h000;
            wr_pntr_bin_reg_actual = 4'h0;
            @(posedge rd_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Idle state", test_num);

            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Single write pointer update", test_num);
            WR_PNTR_RD = 9'h001;
            wr_pntr_bin_reg_actual = 4'h1;
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Status select S change", test_num);
            WR_PNTR_RD = 9'h004;
            S = 2'b01;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Data input Q impact", test_num);
            Q = 32'hDEADBEEF;
            WR_PNTR_RD = 9'h008;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Near-full pointer logic", test_num);
            WR_PNTR_RD = 9'h1F0;
            wr_pntr_bin_reg_actual = 4'hF;
            S = 2'b11;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase %03d: Pointer wraparound check", test_num);
            WR_PNTR_RD = 9'h002;
            wr_pntr_bin_reg_actual = 4'h2;
            S = 2'b10;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(3'b001);
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
        input [2:0] expected_rd_data_count;
        begin
            if (expected_rd_data_count === (expected_rd_data_count ^ rd_data_count ^ expected_rd_data_count)) begin
                $display("PASS");
                $display("  Outputs: rd_data_count=%h",
                         rd_data_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data_count=%h",
                         expected_rd_data_count);
                $display("  Got:      rd_data_count=%h",
                         rd_data_count);
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
        $dumpvars(0,Q, S, WR_PNTR_RD, rd_clk, wr_pntr_bin_reg, rd_data_count);
    end

endmodule
