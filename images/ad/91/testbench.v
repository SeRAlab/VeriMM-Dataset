`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ADR_MUX_IN;
    reg CLK;
    reg MAD_MUX_IN;
    reg PC_load_IN;
    reg SPR_d_IN;
    reg SPR_i_IN;
    reg SPR_w_IN;
    reg SW_IN;
    reg [2:0] cond_IN;
    reg input_IN;
    reg [2:0] op2_IN;
    reg wren_IN;
    reg [2:0] writeAd_IN;
    reg write_IN;
    wire ADR_MUX_OUT;
    wire MAD_MUX_OUT;
    wire PC_load_OUT;
    wire SPR_d_OUT;
    wire SPR_i_OUT;
    wire SPR_w_OUT;
    wire SW_OUT;
    wire [2:0] cond_OUT;
    wire input_OUT;
    wire [2:0] op2_OUT;
    wire wren_OUT;
    wire [2:0] writeAd_OUT;
    wire write_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADR_MUX_IN(ADR_MUX_IN),
        .CLK(CLK),
        .MAD_MUX_IN(MAD_MUX_IN),
        .PC_load_IN(PC_load_IN),
        .SPR_d_IN(SPR_d_IN),
        .SPR_i_IN(SPR_i_IN),
        .SPR_w_IN(SPR_w_IN),
        .SW_IN(SW_IN),
        .cond_IN(cond_IN),
        .input_IN(input_IN),
        .op2_IN(op2_IN),
        .wren_IN(wren_IN),
        .writeAd_IN(writeAd_IN),
        .write_IN(write_IN),
        .ADR_MUX_OUT(ADR_MUX_OUT),
        .MAD_MUX_OUT(MAD_MUX_OUT),
        .PC_load_OUT(PC_load_OUT),
        .SPR_d_OUT(SPR_d_OUT),
        .SPR_i_OUT(SPR_i_OUT),
        .SPR_w_OUT(SPR_w_OUT),
        .SW_OUT(SW_OUT),
        .cond_OUT(cond_OUT),
        .input_OUT(input_OUT),
        .op2_OUT(op2_OUT),
        .wren_OUT(wren_OUT),
        .writeAd_OUT(writeAd_OUT),
        .write_OUT(write_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ADR_MUX_IN = 0;
            MAD_MUX_IN = 0;
            PC_load_IN = 0;
            SPR_d_IN = 0;
            SPR_i_IN = 0;
            SPR_w_IN = 0;
            SW_IN = 0;
            cond_IN = 3'b000;
            input_IN = 0;
            op2_IN = 3'b000;
            wren_IN = 0;
            writeAd_IN = 3'b000;
            write_IN = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            ADR_MUX_IN = 0;
            MAD_MUX_IN = 0;
            PC_load_IN = 0;
            SPR_d_IN = 0;
            SPR_i_IN = 0;
            SPR_w_IN = 0;
            SW_IN = 0;
            cond_IN = 3'b000;
            input_IN = 0;
            op2_IN = 3'b000;
            wren_IN = 0;
            writeAd_IN = 3'b000;
            write_IN = 0;

            @(posedge CLK);
            #2;
            $display("Test Case 001: All Zeros");
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 3'b000, 0, 3'b000, 0, 3'b000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            ADR_MUX_IN = 1;
            MAD_MUX_IN = 1;
            PC_load_IN = 1;
            SPR_d_IN = 1;
            SPR_i_IN = 1;
            SPR_w_IN = 1;
            SW_IN = 1;
            cond_IN = 3'b111;
            input_IN = 1;
            op2_IN = 3'b111;
            wren_IN = 1;
            writeAd_IN = 3'b111;
            write_IN = 1;

            @(posedge CLK);
            #2;
            $display("Test Case 002: All Ones");
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 3'b111, 1, 3'b111, 1, 3'b111, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            ADR_MUX_IN = 1;
            MAD_MUX_IN = 0;
            PC_load_IN = 1;
            SPR_d_IN = 0;
            SPR_i_IN = 1;
            SPR_w_IN = 0;
            SW_IN = 1;
            cond_IN = 3'b101;
            input_IN = 0;
            op2_IN = 3'b010;
            wren_IN = 1;
            writeAd_IN = 3'b110;
            write_IN = 0;

            @(posedge CLK);
            #2;
            $display("Test Case 003: Alternating Patterns");
            #1;

            check_outputs(1, 0, 1, 0, 1, 0, 1, 3'b101, 0, 3'b010, 1, 3'b110, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            ADR_MUX_IN = 0;
            MAD_MUX_IN = 1;
            PC_load_IN = 0;
            SPR_d_IN = 1;
            SPR_i_IN = 0;
            SPR_w_IN = 1;
            SW_IN = 0;
            cond_IN = 3'b011;
            input_IN = 1;
            op2_IN = 3'b100;
            wren_IN = 0;
            writeAd_IN = 3'b001;
            write_IN = 1;

            @(posedge CLK);
            #2;
            $display("Test Case 004: Mixed Signals");
            #1;

            check_outputs(0, 1, 0, 1, 0, 1, 0, 3'b011, 1, 3'b100, 0, 3'b001, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            ADR_MUX_IN = 1;
            cond_IN = 3'b111;
            @(posedge CLK);
            #2;


            ADR_MUX_IN = 0;
            cond_IN = 3'b000;
            #1;
            $display("Test Case 005: Verifying value doesn't change without clock edge");

            #1;


            check_outputs(1, 0, 0, 0, 0, 0, 0, 3'b111, 0, 3'b000, 0, 3'b000, 0);
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
        input expected_ADR_MUX_OUT;
        input expected_MAD_MUX_OUT;
        input expected_PC_load_OUT;
        input expected_SPR_d_OUT;
        input expected_SPR_i_OUT;
        input expected_SPR_w_OUT;
        input expected_SW_OUT;
        input [2:0] expected_cond_OUT;
        input expected_input_OUT;
        input [2:0] expected_op2_OUT;
        input expected_wren_OUT;
        input [2:0] expected_writeAd_OUT;
        input expected_write_OUT;
        begin
            if (expected_ADR_MUX_OUT === (expected_ADR_MUX_OUT ^ ADR_MUX_OUT ^ expected_ADR_MUX_OUT) &&
                expected_MAD_MUX_OUT === (expected_MAD_MUX_OUT ^ MAD_MUX_OUT ^ expected_MAD_MUX_OUT) &&
                expected_PC_load_OUT === (expected_PC_load_OUT ^ PC_load_OUT ^ expected_PC_load_OUT) &&
                expected_SPR_d_OUT === (expected_SPR_d_OUT ^ SPR_d_OUT ^ expected_SPR_d_OUT) &&
                expected_SPR_i_OUT === (expected_SPR_i_OUT ^ SPR_i_OUT ^ expected_SPR_i_OUT) &&
                expected_SPR_w_OUT === (expected_SPR_w_OUT ^ SPR_w_OUT ^ expected_SPR_w_OUT) &&
                expected_SW_OUT === (expected_SW_OUT ^ SW_OUT ^ expected_SW_OUT) &&
                expected_cond_OUT === (expected_cond_OUT ^ cond_OUT ^ expected_cond_OUT) &&
                expected_input_OUT === (expected_input_OUT ^ input_OUT ^ expected_input_OUT) &&
                expected_op2_OUT === (expected_op2_OUT ^ op2_OUT ^ expected_op2_OUT) &&
                expected_wren_OUT === (expected_wren_OUT ^ wren_OUT ^ expected_wren_OUT) &&
                expected_writeAd_OUT === (expected_writeAd_OUT ^ writeAd_OUT ^ expected_writeAd_OUT) &&
                expected_write_OUT === (expected_write_OUT ^ write_OUT ^ expected_write_OUT)) begin
                $display("PASS");
                $display("  Outputs: ADR_MUX_OUT=%b, MAD_MUX_OUT=%b, PC_load_OUT=%b, SPR_d_OUT=%b, SPR_i_OUT=%b, SPR_w_OUT=%b, SW_OUT=%b, cond_OUT=%h, input_OUT=%b, op2_OUT=%h, wren_OUT=%b, writeAd_OUT=%h, write_OUT=%b",
                         ADR_MUX_OUT, MAD_MUX_OUT, PC_load_OUT, SPR_d_OUT, SPR_i_OUT, SPR_w_OUT, SW_OUT, cond_OUT, input_OUT, op2_OUT, wren_OUT, writeAd_OUT, write_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADR_MUX_OUT=%b, MAD_MUX_OUT=%b, PC_load_OUT=%b, SPR_d_OUT=%b, SPR_i_OUT=%b, SPR_w_OUT=%b, SW_OUT=%b, cond_OUT=%h, input_OUT=%b, op2_OUT=%h, wren_OUT=%b, writeAd_OUT=%h, write_OUT=%b",
                         expected_ADR_MUX_OUT, expected_MAD_MUX_OUT, expected_PC_load_OUT, expected_SPR_d_OUT, expected_SPR_i_OUT, expected_SPR_w_OUT, expected_SW_OUT, expected_cond_OUT, expected_input_OUT, expected_op2_OUT, expected_wren_OUT, expected_writeAd_OUT, expected_write_OUT);
                $display("  Got:      ADR_MUX_OUT=%b, MAD_MUX_OUT=%b, PC_load_OUT=%b, SPR_d_OUT=%b, SPR_i_OUT=%b, SPR_w_OUT=%b, SW_OUT=%b, cond_OUT=%h, input_OUT=%b, op2_OUT=%h, wren_OUT=%b, writeAd_OUT=%h, write_OUT=%b",
                         ADR_MUX_OUT, MAD_MUX_OUT, PC_load_OUT, SPR_d_OUT, SPR_i_OUT, SPR_w_OUT, SW_OUT, cond_OUT, input_OUT, op2_OUT, wren_OUT, writeAd_OUT, write_OUT);
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
        $dumpvars(0,ADR_MUX_IN, CLK, MAD_MUX_IN, PC_load_IN, SPR_d_IN, SPR_i_IN, SPR_w_IN, SW_IN, cond_IN, input_IN, op2_IN, wren_IN, writeAd_IN, write_IN, ADR_MUX_OUT, MAD_MUX_OUT, PC_load_OUT, SPR_d_OUT, SPR_i_OUT, SPR_w_OUT, SW_OUT, cond_OUT, input_OUT, op2_OUT, wren_OUT, writeAd_OUT, write_OUT);
    end

endmodule
