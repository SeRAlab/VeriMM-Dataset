`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg in_valid;
    reg nrst;
    reg out_ready;
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
        .nrst(nrst),
        .out_ready(out_ready),
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
            nrst = 0;
            in_valid = 0;
            in_data = 0;
            out_ready = 0;
            repeat(2) @(posedge clk);
            #1 nrst = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Write and Verify", test_num);
            reset_dut();

            in_data = 8'hA5;
            in_valid = 1;
            @(posedge clk);
            #1;
            in_valid = 0;


            #1;



            check_outputs(1'b1, 8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill FIFO to Full", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                in_data = 8'h10 + i;
                in_valid = 1;
                @(posedge clk);
            end
            #1;
            in_valid = 0;


            #1;



            check_outputs(1'b0, 8'h10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill and Empty", test_num);
            reset_dut();


            in_valid = 1;
            in_data = 8'h55; @(posedge clk);
            in_data = 8'hAA; @(posedge clk);
            in_valid = 0;


            out_ready = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            out_ready = 0;



            #1;




            check_outputs(1'b1, out_data, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Prevention", test_num);
            reset_dut();


            in_valid = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                in_data = i;
                @(posedge clk);
            end

            in_data = 8'hFF;
            @(posedge clk);
            in_valid = 0;


            out_ready = 1;
            repeat(8) @(posedge clk);
            #1;
            out_ready = 0;


            #1;



            check_outputs(1'b1, out_data, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            in_data = 8'hD1;
            in_valid = 1;
            @(posedge clk);


            in_data = 8'hD2;
            in_valid = 1;
            out_ready = 1;
            @(posedge clk);
            #1;
            in_valid = 0;
            out_ready = 0;


            #1;



            check_outputs(1'b1, 8'hD2, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap Around Pointer Check", test_num);
            reset_dut();


            in_valid = 1;
            for (i = 0; i < 5; i = i + 1) begin
                in_data = i + 1;
                @(posedge clk);
            end
            in_valid = 0;


            out_ready = 1;
            repeat(5) @(posedge clk);
            out_ready = 0;


            in_valid = 1;
            for (i = 10; i < 16; i = i + 1) begin
                in_data = i;
                @(posedge clk);
            end
            in_valid = 0;
            #1;


            #1;



            check_outputs(1'b1, 8'h0A, 1'b1);
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
        input expected_in_ready;
        input [7:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: in_ready=%b, out_data=%h, out_valid=%b",
                         in_ready, out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_ready=%b, out_data=%h, out_valid=%b",
                         expected_in_ready, expected_out_data, expected_out_valid);
                $display("  Got:      in_ready=%b, out_data=%h, out_valid=%b",
                         in_ready, out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, nrst, out_ready, in_ready, out_data, out_valid);
    end

endmodule
