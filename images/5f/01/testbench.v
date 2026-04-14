`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg rd;
    reg rst;
    reg wr;
    wire empty;
    wire full;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_data(input_data),
        .rd(rd),
        .rst(rst),
        .wr(wr),
        .empty(empty),
        .full(full),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rd = 0;
            wr = 0;
            input_data = 0;
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
            reset_dut();

            $display("Testcase %0d: Checking Reset State", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wr = 1;
            input_data = 8'hA5;
            @(posedge clk);
            #1;
            wr = 0;

            $display("Testcase %0d: Single Write", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            wr = 1;
            for (i = 0; i < 8; i = i + 1) begin
                input_data = i + 1;
                @(posedge clk);
                #1;
            end
            wr = 0;

            $display("Testcase %0d: Fill FIFO to Full", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wr = 1;
            input_data = 8'h55;
            @(posedge clk);
            #1;
            wr = 0;

            rd = 1;
            @(posedge clk);
            #1;
            rd = 0;

            $display("Testcase %0d: Write and Read Back", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            wr = 1; input_data = 8'h11; @(posedge clk); #1;

            wr = 1; input_data = 8'h22; @(posedge clk); #1;
            wr = 0;

            rd = 1; @(posedge clk); #1;
            rd = 0;

            $display("Testcase %0d: FIFO Order Verification", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 8'h22);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();

            wr = 1;
            for (i = 0; i < 8; i = i + 1) begin
                input_data = i;
                @(posedge clk);
                #1;
            end
            wr = 0;

            rd = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            rd = 0;
            $display("Testcase %0d: Fill then Empty Completely", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 8'h07);
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_output_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, output_data=%h",
                         empty, full, output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, output_data=%h",
                         expected_empty, expected_full, expected_output_data);
                $display("  Got:      empty=%b, full=%b, output_data=%h",
                         empty, full, output_data);
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
        $dumpvars(0,clk, input_data, rd, rst, wr, empty, full, output_data);
    end

endmodule
