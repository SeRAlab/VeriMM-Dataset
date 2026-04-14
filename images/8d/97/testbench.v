`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_108m;
    reg data_valid;
    reg [7:0] din0;
    reg [7:0] din1;
    reg rst_n;
    wire [15:0] out_fifo_wdata;
    wire out_fifo_wren;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_108m(clk_108m),
        .data_valid(data_valid),
        .din0(din0),
        .din1(din1),
        .rst_n(rst_n),
        .out_fifo_wdata(out_fifo_wdata),
        .out_fifo_wren(out_fifo_wren)
    );

    // Clock generation (10ns period)
    initial begin
        clk_108m = 0;
        forever #5 clk_108m = ~clk_108m;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_valid = 0;
            din0 = 8'h00;
            din1 = 8'h00;
            repeat(2) @(posedge clk_108m);
            #1 rst_n = 1;
            repeat(1) @(posedge clk_108m);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            rst_n = 0;
            data_valid = 1;
            din0 = 8'hAA;
            din1 = 8'hBB;
            @(posedge clk_108m);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Valid Write", test_num);
            reset_dut();
            data_valid = 1;
            din0 = 8'h12;
            din1 = 8'h34;
            @(posedge clk_108m);
            #1;
            #1;

            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Data Invalid Operation", test_num);
            reset_dut();
            data_valid = 0;
            din0 = 8'hFF;
            din1 = 8'hEE;
            @(posedge clk_108m);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Boundary Values (All High)", test_num);
            reset_dut();
            data_valid = 1;
            din0 = 8'hFF;
            din1 = 8'hFF;
            @(posedge clk_108m);
            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Alternating Valid Signal", test_num);
            reset_dut();


            data_valid = 1;
            din0 = 8'hA1;
            din1 = 8'hB2;
            @(posedge clk_108m);


            #1;
            data_valid = 0;
            din0 = 8'h00;
            din1 = 8'h00;
            @(posedge clk_108m);
            #1;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Sequence of Writes", test_num);
            reset_dut();

            data_valid = 1;
            din0 = 8'hDE; din1 = 8'hAD;
            @(posedge clk_108m);

            #1;
            din0 = 8'hBE; din1 = 8'hEF;
            @(posedge clk_108m);
            #1;

            #1;


            check_outputs(16'hBEEF, 1'b1);
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
        input [15:0] expected_out_fifo_wdata;
        input expected_out_fifo_wren;
        begin
            if (expected_out_fifo_wdata === (expected_out_fifo_wdata ^ out_fifo_wdata ^ expected_out_fifo_wdata) &&
                expected_out_fifo_wren === (expected_out_fifo_wren ^ out_fifo_wren ^ expected_out_fifo_wren)) begin
                $display("PASS");
                $display("  Outputs: out_fifo_wdata=%h, out_fifo_wren=%b",
                         out_fifo_wdata, out_fifo_wren);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_fifo_wdata=%h, out_fifo_wren=%b",
                         expected_out_fifo_wdata, expected_out_fifo_wren);
                $display("  Got:      out_fifo_wdata=%h, out_fifo_wren=%b",
                         out_fifo_wdata, out_fifo_wren);
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
        $dumpvars(0,clk_108m, data_valid, din0, din1, rst_n, out_fifo_wdata, out_fifo_wren);
    end

endmodule
