`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [11:0] exponent_term;
    reg [55:0] mantissa_term;
    reg [1:0] round_mode;
    reg rst;
    reg sign_term;
    wire [11:0] exponent_final;
    wire [63:0] round_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .exponent_term(exponent_term),
        .mantissa_term(mantissa_term),
        .round_mode(round_mode),
        .rst(rst),
        .sign_term(sign_term),
        .exponent_final(exponent_final),
        .round_out(round_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            exponent_term = 0;
            mantissa_term = 0;
            round_mode = 0;
            sign_term = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            enable = 1;
            round_mode = 2'b00;
            sign_term = 0;
            exponent_term = 12'h3FF;
            mantissa_term = 56'hA0000000000000;

            #1;


            check_outputs(12'h3FF, 64'h3FF0000000000000 | 64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 1;
            round_mode = 2'b00;
            sign_term = 0;
            exponent_term = 12'h3FF;
            mantissa_term = 56'h00000000000018;

            #1;


            check_outputs(12'h3FF, 64'h3FF0000000000002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            round_mode = 2'b01;
            sign_term = 1;
            exponent_term = 12'h400;
            mantissa_term = 56'hFFFFFFFFFFFFF8;

            #1;


            check_outputs(12'h400, 64'hC00FFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;
            round_mode = 2'b10;
            sign_term = 0;
            exponent_term = 12'h3FF;
            mantissa_term = 56'h00000000000001;
            #1;

            check_outputs(12'h3FF, 64'h3FF0000000000001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            round_mode = 2'b11;
            sign_term = 1;
            exponent_term = 12'h3FF;
            mantissa_term = 56'h00000000000001;
            #1;

            check_outputs(12'h3FF, 64'hBFF0000000000001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable = 1;
            round_mode = 2'b00;
            sign_term = 0;
            exponent_term = 12'h3FF;
            mantissa_term = 56'hFFFFFFFFFFFFF8;

            #1;


            check_outputs(12'h400, 64'h4000000000000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enable = 0;
            round_mode = 2'b00;
            sign_term = 0;
            exponent_term = 12'hABC;
            mantissa_term = 56'h123456789ABCDE;


            #1;



            check_outputs(12'h000, 64'h0000000000000000);
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
        input [11:0] expected_exponent_final;
        input [63:0] expected_round_out;
        begin
            if (expected_exponent_final === (expected_exponent_final ^ exponent_final ^ expected_exponent_final) &&
                expected_round_out === (expected_round_out ^ round_out ^ expected_round_out)) begin
                $display("PASS");
                $display("  Outputs: exponent_final=%h, round_out=%h",
                         exponent_final, round_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exponent_final=%h, round_out=%h",
                         expected_exponent_final, expected_round_out);
                $display("  Got:      exponent_final=%h, round_out=%h",
                         exponent_final, round_out);
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
        $dumpvars(0,clk, enable, exponent_term, mantissa_term, round_mode, rst, sign_term, exponent_final, round_out);
    end

endmodule
