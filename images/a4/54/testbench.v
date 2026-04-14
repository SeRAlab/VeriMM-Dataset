`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] D;
    reg wr_clk;
    wire [7:0] O1;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .wr_clk(wr_clk),
        .O1(O1),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

        task reset_dut;

        begin
            D <= 8'h00;

            repeat(2) @(posedge wr_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 0x00", test_num);
            D <= 8'h00;
            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 0x01 (LSB Toggle)", test_num);
            D <= 8'h01;
            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 0xFF (All High)", test_num);
            D <= 8'hFF;
            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 0xAA (Alternating 1010)", test_num);
            D <= 8'hAA;
            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 0x55 (Alternating 0101)", test_num);
            D <= 8'h55;
            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: High Nibble 0xF0", test_num);
            D <= 8'hF0;
            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'hF0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 0x73", test_num);
            D <= 8'h73;
            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'h73, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data Transition Check", test_num);
            D <= 8'h12;
            repeat(2) @(posedge wr_clk);
            #1;
            #1;

            check_outputs(8'h12, 1'b0);
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
        testcase008();
        
        
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
        input [7:0] expected_O1;
        input expected_Q;
        begin
            if (expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: O1=%h, Q=%b",
                         O1, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O1=%h, Q=%b",
                         expected_O1, expected_Q);
                $display("  Got:      O1=%h, Q=%b",
                         O1, Q);
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
        $dumpvars(0,D, wr_clk, O1, Q);
    end

endmodule
