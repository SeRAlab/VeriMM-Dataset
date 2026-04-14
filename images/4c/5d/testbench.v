`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire [7:0] po;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .po(po),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            si = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %03d: Shift All Ones", test_num);
            reset_dut();
            si = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Shift Pattern 0xAA (1,0,1,0,1,0,1,0)", test_num);
            reset_dut();
            pattern = 8'b10101010;
            for (i = 7; i >= 0; i = i - 1) begin
                si = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Shift Pattern 0x55 (0,1,0,1,0,1,0,1)", test_num);
            reset_dut();
            pattern = 8'b01010101;
            for (i = 7; i >= 0; i = i - 1) begin
                si = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase005;

        reg [11:0] pattern;
        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Overflow Test (12 bits)", test_num);
            reset_dut();
            pattern = 12'b1111_00001111;
            for (i = 11; i >= 0; i = i - 1) begin
                si = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hF0, 1'b0);
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
        input [7:0] expected_po;
        input expected_so;
        begin
            if (expected_po === (expected_po ^ po ^ expected_po) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: po=%h, so=%b",
                         po, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po=%h, so=%b",
                         expected_po, expected_so);
                $display("  Got:      po=%h, so=%b",
                         po, so);
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
        $dumpvars(0,clk, rst, si, po, so);
    end

endmodule
