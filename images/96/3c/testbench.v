`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [35:0] bv_1;
    reg [35:0] bv_2;
    reg [35:0] bv_3;
    reg [35:0] bv_4;
    reg bv_in_valid;
    reg clk;
    reg reset;
    wire [63:0] bv_out;
    wire bv_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bv_1(bv_1),
        .bv_2(bv_2),
        .bv_3(bv_3),
        .bv_4(bv_4),
        .bv_in_valid(bv_in_valid),
        .clk(clk),
        .reset(reset),
        .bv_out(bv_out),
        .bv_out_valid(bv_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bv_1 = 36'b0;
            bv_2 = 36'b0;
            bv_3 = 36'b0;
            bv_4 = 36'b0;
            bv_in_valid = 1'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            bv_1 = 36'hF_FFFF_FFFF;
            bv_2 = 36'hF_FFFF_FFFF;
            bv_3 = 36'hF_FFFF_FFFF;
            bv_4 = 36'hF_FFFF_FFFF;
            bv_in_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000F_FFFF_FFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            bv_1 = 36'hF_FFFF_FFFF;
            bv_2 = 36'h0_0000_0000;
            bv_3 = 36'hF_FFFF_FFFF;
            bv_4 = 36'hF_FFFF_FFFF;
            bv_in_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000_0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            bv_1 = 36'hA_AAAA_AAAA;
            bv_2 = 36'h5_5555_5555;
            bv_3 = 36'hF_FFFF_FFFF;
            bv_4 = 36'hF_FFFF_FFFF;
            bv_in_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000_0000_0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            bv_1 = 36'hF_FFFF_FFFF;
            bv_2 = 36'hF_FFFF_FFFF;
            bv_3 = 36'hF_FFFF_FFFF;
            bv_4 = 36'hF_FFFF_FFFF;
            bv_in_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            bv_1 = 36'hF_0F0F_0F0F;
            bv_2 = 36'hF_F0F0_F0F0;
            bv_3 = 36'hF_FFFF_FFFF;
            bv_4 = 36'hF_0000_FFFF;

            bv_in_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000F_0000_F0F0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            bv_1 = 36'h0_0000_0001;
            bv_2 = 36'h0_0000_0001;
            bv_3 = 36'h0_0000_0001;
            bv_4 = 36'h0_0000_0001;
            bv_in_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000_0000_0001, 1'b1);
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
        input [63:0] expected_bv_out;
        input expected_bv_out_valid;
        begin
            if (expected_bv_out === (expected_bv_out ^ bv_out ^ expected_bv_out) &&
                expected_bv_out_valid === (expected_bv_out_valid ^ bv_out_valid ^ expected_bv_out_valid)) begin
                $display("PASS");
                $display("  Outputs: bv_out=%h, bv_out_valid=%b",
                         bv_out, bv_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bv_out=%h, bv_out_valid=%b",
                         expected_bv_out, expected_bv_out_valid);
                $display("  Got:      bv_out=%h, bv_out_valid=%b",
                         bv_out, bv_out_valid);
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
        $dumpvars(0,bv_1, bv_2, bv_3, bv_4, bv_in_valid, clk, reset, bv_out, bv_out_valid);
    end

endmodule
