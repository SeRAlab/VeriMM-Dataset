`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg in_valid;
    reg out_ready;
    reg rst;
    wire error;
    wire in_ready;
    wire [7:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .rst(rst),
        .error(error),
        .in_ready(in_ready),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_data = 0;
            in_valid = 0;
            out_ready = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            in_data = 8'hA5;
            in_valid = 1;
            @(posedge clk);
            in_valid = 0;


            @(posedge clk);
            out_ready = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 8'hA5, 1'b1);
            out_ready = 0;
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill FIFO to capacity", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                in_data = i;
                in_valid = 1;
            end
            @(posedge clk);
            in_valid = 0;
            #1;



            #1;




            check_outputs(1'b0, 1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Underflow Error Trigger", test_num);
            reset_dut();


            @(posedge clk);
            out_ready = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b1, 8'hzz, 1'b0);
            out_ready = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            in_data = 8'h11;
            in_valid = 1;
            @(posedge clk);


            in_data = 8'h22;
            in_valid = 1;
            out_ready = 1;
            @(posedge clk);


            in_valid = 0;
            out_ready = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 8'h22, 1'b1);
            out_ready = 0;
        end
        endtask

    task testcase005;

        integer j;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full to Empty transition", test_num);
            reset_dut();


            for (j = 0; j < 16; j = j + 1) begin
                @(posedge clk);
                in_data = j + 8'h10;
                in_valid = 1;
            end
            @(posedge clk);
            in_valid = 0;


            out_ready = 1;
            repeat(15) @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 8'h1F, 1'b1);
            out_ready = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset mid-operation", test_num);
            reset_dut();


            @(posedge clk);
            in_data = 8'hAA;
            in_valid = 1;
            @(posedge clk);
            in_data = 8'hBB;
            @(posedge clk);
            in_valid = 0;


            rst = 1;
            #20;
            rst = 0;
            #10;


            #1;



            check_outputs(1'b0, 1'b1, 8'h00, 1'b0);
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
        input expected_error;
        input expected_in_ready;
        input [7:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: error=%b, in_ready=%b, out_data=%h, out_valid=%b",
                         error, in_ready, out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, in_ready=%b, out_data=%h, out_valid=%b",
                         expected_error, expected_in_ready, expected_out_data, expected_out_valid);
                $display("  Got:      error=%b, in_ready=%b, out_data=%h, out_valid=%b",
                         error, in_ready, out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, out_ready, rst, error, in_ready, out_data, out_valid);
    end

endmodule
