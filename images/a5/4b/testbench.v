`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_en;
    reg rst;
    reg [7:0] write_data;
    reg write_en;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_en(read_en),
        .rst(rst),
        .write_data(write_data),
        .write_en(write_en),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        write_en = 0;
        read_en = 0;
        write_data = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(posedge clk);
        write_en = 1;
        write_data = 8'hA5;
        @(posedge clk);
        write_en = 0;


        @(posedge clk);
        read_en = 1;
        @(posedge clk);
        read_en = 0;
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(posedge clk);
        write_en = 1; write_data = 8'h11; @(posedge clk);
        write_en = 1; write_data = 8'h22; @(posedge clk);
        write_en = 1; write_data = 8'h33; @(posedge clk);
        write_en = 0;


        @(posedge clk);
        read_en = 1;
        @(posedge clk);
        read_en = 0;
        #1;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(posedge clk);
        write_en = 1; write_data = 8'hAA; @(posedge clk);
        write_en = 1; write_data = 8'hBB; @(posedge clk);
        write_en = 0;


        @(posedge clk);
        read_en = 1; @(posedge clk);

        read_en = 1; @(posedge clk);
        read_en = 0;

        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(posedge clk);
        write_en = 1; write_data = 8'h01; @(posedge clk);
        write_en = 1; write_data = 8'h02; @(posedge clk);
        write_en = 0;


        @(posedge clk);
        read_en = 1; @(posedge clk);
        read_en = 0;


        @(posedge clk);
        write_en = 1; write_data = 8'h03; @(posedge clk);
        write_en = 0;


        @(posedge clk);
        read_en = 1; @(posedge clk);


        read_en = 1; @(posedge clk);
        read_en = 0;

        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(posedge clk);
        write_en = 1; write_data = 8'hFF; @(posedge clk);
        write_en = 0;


        rst = 1;
        @(posedge clk);
        rst = 0;


        @(posedge clk);
        write_en = 1; write_data = 8'h55; @(posedge clk);
        write_en = 0;


        @(posedge clk);
        read_en = 1; @(posedge clk);
        read_en = 0;

        #1;
        #1;

        check_outputs(8'h55);
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
        input [7:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_en, rst, write_data, write_en, read_data);
    end

endmodule
