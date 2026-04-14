`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] adder_out;
    reg [31:0] aluout;
    reg aluzero;
    reg clk;
    reg [2:0] ctlm_out;
    reg [1:0] ctlwb_out;
    reg [4:0] muxout;
    reg [31:0] readdat2;
    wire [31:0] add_result;
    wire [31:0] alu_result;
    wire [4:0] five_bit_muxout;
    wire [2:0] m_ctlout;
    wire [31:0] rdata2out;
    wire [1:0] wb_ctlout;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adder_out(adder_out),
        .aluout(aluout),
        .aluzero(aluzero),
        .clk(clk),
        .ctlm_out(ctlm_out),
        .ctlwb_out(ctlwb_out),
        .muxout(muxout),
        .readdat2(readdat2),
        .add_result(add_result),
        .alu_result(alu_result),
        .five_bit_muxout(five_bit_muxout),
        .m_ctlout(m_ctlout),
        .rdata2out(rdata2out),
        .wb_ctlout(wb_ctlout),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctlwb_out = 2'b0;
            ctlm_out = 3'b0;
            adder_out = 32'b0;
            aluzero = 1'b0;
            aluout = 32'b0;
            readdat2 = 32'b0;
            muxout = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            ctlwb_out = 2'b10;
            ctlm_out = 3'b101;
            adder_out = 32'h12345678;
            aluzero = 1'b0;
            aluout = 32'hABCDE000;
            readdat2 = 32'h5555AAAA;
            muxout = 5'd15;


            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h12345678, 32'hABCDE000, 5'd15, 3'b101, 32'h5555AAAA, 2'b10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            ctlwb_out = 2'b11;
            ctlm_out = 3'b111;
            adder_out = 32'hFFFFFFFF;
            aluzero = 1'b1;
            aluout = 32'hFFFFFFFF;
            readdat2 = 32'hFFFFFFFF;
            muxout = 5'b11111;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 5'b11111, 3'b111, 32'hFFFFFFFF, 2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            ctlwb_out = 2'b01;
            ctlm_out = 3'b010;
            adder_out = 32'h5A5A5A5A;
            aluzero = 1'b0;
            aluout = 32'hA5A5A5A5;
            readdat2 = 32'h0F0F0F0F;
            muxout = 5'b01010;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h5A5A5A5A, 32'hA5A5A5A5, 5'b01010, 3'b010, 32'h0F0F0F0F, 2'b01, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            ctlwb_out = 2'b11;
            aluout = 32'h11111111;
            @(posedge clk);
            #1;


            ctlwb_out = 2'b00;
            aluout = 32'h22222222;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 32'h22222222, 5'b00000, 3'b000, 32'h00000000, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            muxout = 5'b11011;
            adder_out = 32'h00000040;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000040, 32'h0, 5'b11011, 3'b0, 32'h0, 2'b0, 1'b0);
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
        input [31:0] expected_add_result;
        input [31:0] expected_alu_result;
        input [4:0] expected_five_bit_muxout;
        input [2:0] expected_m_ctlout;
        input [31:0] expected_rdata2out;
        input [1:0] expected_wb_ctlout;
        input expected_zero;
        begin
            if (expected_add_result === (expected_add_result ^ add_result ^ expected_add_result) &&
                expected_alu_result === (expected_alu_result ^ alu_result ^ expected_alu_result) &&
                expected_five_bit_muxout === (expected_five_bit_muxout ^ five_bit_muxout ^ expected_five_bit_muxout) &&
                expected_m_ctlout === (expected_m_ctlout ^ m_ctlout ^ expected_m_ctlout) &&
                expected_rdata2out === (expected_rdata2out ^ rdata2out ^ expected_rdata2out) &&
                expected_wb_ctlout === (expected_wb_ctlout ^ wb_ctlout ^ expected_wb_ctlout) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: add_result=%h, alu_result=%h, five_bit_muxout=%h, m_ctlout=%h, rdata2out=%h, wb_ctlout=%h, zero=%b",
                         add_result, alu_result, five_bit_muxout, m_ctlout, rdata2out, wb_ctlout, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_result=%h, alu_result=%h, five_bit_muxout=%h, m_ctlout=%h, rdata2out=%h, wb_ctlout=%h, zero=%b",
                         expected_add_result, expected_alu_result, expected_five_bit_muxout, expected_m_ctlout, expected_rdata2out, expected_wb_ctlout, expected_zero);
                $display("  Got:      add_result=%h, alu_result=%h, five_bit_muxout=%h, m_ctlout=%h, rdata2out=%h, wb_ctlout=%h, zero=%b",
                         add_result, alu_result, five_bit_muxout, m_ctlout, rdata2out, wb_ctlout, zero);
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
        $dumpvars(0,adder_out, aluout, aluzero, clk, ctlm_out, ctlwb_out, muxout, readdat2, add_result, alu_result, five_bit_muxout, m_ctlout, rdata2out, wb_ctlout, zero);
    end

endmodule
