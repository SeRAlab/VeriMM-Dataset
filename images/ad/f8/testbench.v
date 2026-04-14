`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] data;
    reg wr;
    wire [4:0] D;
    wire [2:0] RS_RW_E;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .data(data),
        .wr(wr),
        .D(D),
        .RS_RW_E(RS_RW_E)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            wr = 0;
            data = 0;
            @(posedge clk);
            #1;
            clr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(5'h00, 3'b000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data = 8'b101_10101;
            wr = 1;
            @(posedge clk);
            #1;
            wr = 0;
            #1;

            check_outputs(5'h15, 3'b101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data = 8'hFF;
            wr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 3'b000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            data = 8'hAA;
            wr = 1;
            @(posedge clk);
            #1;

            data = 8'h55;
            @(posedge clk);
            #1;
            wr = 0;
            #1;

            check_outputs(5'h15, 3'b010);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data = 8'hFF;
            wr = 1;
            clr = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 3'b000);
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
        input [4:0] expected_D;
        input [2:0] expected_RS_RW_E;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_RS_RW_E === (expected_RS_RW_E ^ RS_RW_E ^ expected_RS_RW_E)) begin
                $display("PASS");
                $display("  Outputs: D=%h, RS_RW_E=%h",
                         D, RS_RW_E);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, RS_RW_E=%h",
                         expected_D, expected_RS_RW_E);
                $display("  Got:      D=%h, RS_RW_E=%h",
                         D, RS_RW_E);
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
        $dumpvars(0,clk, clr, data, wr, D, RS_RW_E);
    end

endmodule
