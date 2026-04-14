`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] wr_data;
    reg wr_en;
    wire [31:0] rd_data;
    wire [1:0] rd_guards;
    wire [1:0] rd_guardsok;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data(rd_data),
        .rd_guards(rd_guards),
        .rd_guardsok(rd_guardsok)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 1;
            wr_data = 32'h0;
            @(posedge clk);
            #1;
            wr_en = 0;
            wr_data = 32'h0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Writing standard hex value", test_num);
            reset_dut();

            wr_en = 1;
            wr_data = 32'hA5A5B6B6;
            @(posedge clk);
            #1;
            wr_en = 0;




            #1;





            check_outputs(32'hA5A5B6B6, 2'h2, 2'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Verify wr_en = 0 prevents data update", test_num);
            reset_dut();

            wr_en = 0;
            wr_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000000, 2'h0, 2'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Writing all 1s", test_num);
            reset_dut();

            wr_en = 1;
            wr_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            wr_en = 0;


            #1;



            check_outputs(32'hFFFFFFFF, 2'h3, 2'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Writing value with guard bits 01", test_num);
            reset_dut();

            wr_en = 1;
            wr_data = 32'h40000001;
            @(posedge clk);
            #1;
            wr_en = 0;


            #1;



            check_outputs(32'h40000001, 2'h1, 2'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Consecutive writes", test_num);
            reset_dut();

            wr_en = 1;
            wr_data = 32'h12345678;
            @(posedge clk);
            #1;
            wr_data = 32'h87654321;
            @(posedge clk);
            #1;
            wr_en = 0;


            #1;



            check_outputs(32'h87654321, 2'h2, 2'h3);
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
        input [31:0] expected_rd_data;
        input [1:0] expected_rd_guards;
        input [1:0] expected_rd_guardsok;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data) &&
                expected_rd_guards === (expected_rd_guards ^ rd_guards ^ expected_rd_guards) &&
                expected_rd_guardsok === (expected_rd_guardsok ^ rd_guardsok ^ expected_rd_guardsok)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h, rd_guards=%h, rd_guardsok=%h",
                         rd_data, rd_guards, rd_guardsok);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h, rd_guards=%h, rd_guardsok=%h",
                         expected_rd_data, expected_rd_guards, expected_rd_guardsok);
                $display("  Got:      rd_data=%h, rd_guards=%h, rd_guardsok=%h",
                         rd_data, rd_guards, rd_guardsok);
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
        $dumpvars(0,clk, wr_data, wr_en, rd_data, rd_guards, rd_guardsok);
    end

endmodule
