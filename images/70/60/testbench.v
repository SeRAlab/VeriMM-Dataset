`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [7:0] final_output;
    wire [2:0] q_count;
    wire [7:0] q_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .final_output(final_output),
        .q_count(q_count),
        .q_reg(q_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 3'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single bit set (d=01)", test_num);
            reset_dut();
            d = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 3'h1, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multi-cycle shifting (d=01 then d=03)", test_num);
            reset_dut();
            d = 8'h01; @(posedge clk); #1;
            d = 8'h03; @(posedge clk); #1;
            #1;

            check_outputs(8'h03, 3'h2, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift in zero, count 4 (d=01 then d=F0)", test_num);
            reset_dut();
            d = 8'h01; @(posedge clk); #1;
            d = 8'hF0; @(posedge clk); #1;
            #1;

            check_outputs(8'h02, 3'h4, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Population count saturation/wrap (d=FF)", test_num);
            reset_dut();
            d = 8'hFF; @(posedge clk); #1;

            #1;


            check_outputs(8'h00, 3'h0, 8'h01);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fill Shift Register (8 cycles)", test_num);
            reset_dut();
            d = 8'h01;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk); #1;
            end



            #1;




            check_outputs(8'h01, 3'h1, 8'hFF);
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
        input [7:0] expected_final_output;
        input [2:0] expected_q_count;
        input [7:0] expected_q_reg;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_q_count === (expected_q_count ^ q_count ^ expected_q_count) &&
                expected_q_reg === (expected_q_reg ^ q_reg ^ expected_q_reg)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, q_count=%h, q_reg=%h",
                         final_output, q_count, q_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, q_count=%h, q_reg=%h",
                         expected_final_output, expected_q_count, expected_q_reg);
                $display("  Got:      final_output=%h, q_count=%h, q_reg=%h",
                         final_output, q_count, q_reg);
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
        $dumpvars(0,clk, d, reset, final_output, q_count, q_reg);
    end

endmodule
