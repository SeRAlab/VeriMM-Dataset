`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_count;
    reg in_valid;
    reg out_ready;
    reg rst;
    wire in_ready;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_count(in_count),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .rst(rst),
        .in_ready(in_ready),
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
            in_count = 0;
            in_valid = 0;
            out_ready = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Load and Consume", test_num);
            reset_dut();


            in_count = 32'd5;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;
            in_count = 0;


            out_ready = 1;
            repeat (5) @(posedge clk);
            #1;
            out_ready = 0;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Zero Items", test_num);
            reset_dut();

            in_count = 32'd0;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Out Ready Low Persistence", test_num);
            reset_dut();

            in_count = 32'd10;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;


            repeat (5) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Back-to-back Transfers", test_num);
            reset_dut();


            in_count = 32'd2;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;


            out_ready = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            out_ready = 0;


            in_count = 32'd1;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset During Processing", test_num);
            reset_dut();

            in_count = 32'd100;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;


            out_ready = 1;
            repeat (5) @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(1'b1, 1'b0);
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
        input expected_in_ready;
        input expected_out_valid;
        begin
            if (expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: in_ready=%b, out_valid=%b",
                         in_ready, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_ready=%b, out_valid=%b",
                         expected_in_ready, expected_out_valid);
                $display("  Got:      in_ready=%b, out_valid=%b",
                         in_ready, out_valid);
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
        $dumpvars(0,clk, in_count, in_valid, out_ready, rst, in_ready, out_valid);
    end

endmodule
