`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] i_addr;
    reg i_clk;
    wire [13:0] o_addr;
    wire o_neg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_addr(i_addr),
        .i_clk(i_clk),
        .o_addr(o_addr),
        .o_neg(o_neg)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_addr = 16'h0000;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSBs '00' - Direct Pass Through", test_num);
            reset_dut();
            i_addr = 16'h0A5A;
            @(posedge i_clk);
            #2;
            #1;

            check_outputs(14'h0A5A, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSBs '01' - Negation, Neg=0", test_num);
            reset_dut();
            i_addr = 16'h4000;
            @(posedge i_clk);
            #2;
            #1;

            check_outputs(14'h3FFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSBs '10' - Negation, Neg=1", test_num);
            reset_dut();
            i_addr = 16'h8001;
            @(posedge i_clk);
            #2;
            #1;

            check_outputs(14'h3FFE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSBs '11' - Negation, Neg=1", test_num);
            reset_dut();
            i_addr = 16'hC000;
            @(posedge i_clk);
            #2;
            #1;

            check_outputs(14'h3FFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSBs '00' - Upper Bound 14-bit", test_num);
            reset_dut();
            i_addr = 16'h3FFF;
            @(posedge i_clk);
            #2;
            #1;

            check_outputs(14'h3FFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSBs '01' - Pattern Negation", test_num);
            reset_dut();
            i_addr = 16'h5555;

            @(posedge i_clk);
            #2;
            #1;

            check_outputs(14'h2AAA, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSBs '11' - Input All Ones", test_num);
            reset_dut();
            i_addr = 16'hFFFF;
            @(posedge i_clk);
            #2;
            #1;

            check_outputs(14'h0000, 1'b1);
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
        input [13:0] expected_o_addr;
        input expected_o_neg;
        begin
            if (expected_o_addr === (expected_o_addr ^ o_addr ^ expected_o_addr) &&
                expected_o_neg === (expected_o_neg ^ o_neg ^ expected_o_neg)) begin
                $display("PASS");
                $display("  Outputs: o_addr=%h, o_neg=%b",
                         o_addr, o_neg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_addr=%h, o_neg=%b",
                         expected_o_addr, expected_o_neg);
                $display("  Got:      o_addr=%h, o_neg=%b",
                         o_addr, o_neg);
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
        $dumpvars(0,i_addr, i_clk, o_addr, o_neg);
    end

endmodule
