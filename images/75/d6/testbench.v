`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg acapture;
    reg clk;
    reg [7:0] data;
    reg rdclk;
    wire [9:0] horiz_count;
    wire [15:0] wrdata;
    wire write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .acapture(acapture),
        .clk(clk),
        .data(data),
        .rdclk(rdclk),
        .horiz_count(horiz_count),
        .wrdata(wrdata),
        .write(write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            acapture = 0;
            data = 8'h00;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(10'h000, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            acapture = 1;
            data = 8'hAA;
            @(negedge clk);
            data = 8'hBB;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd1, 16'hAABB, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            acapture = 1;


            data = 8'h11; @(negedge clk);
            data = 8'h22; @(negedge clk);

            data = 8'h33; @(negedge clk);
            data = 8'h44; @(negedge clk);

            data = 8'h55; @(negedge clk);
            data = 8'h66; @(negedge clk);

            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd3, 16'h5566, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            acapture = 1;
            data = 8'hA1; @(negedge clk);
            data = 8'hB1; @(negedge clk);

            data = 8'hC1; @(negedge clk);
            acapture = 0;
            repeat (2) @(negedge clk);


            #1;



            check_outputs(10'd0, 16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            acapture = 1;
            data = 8'hFF; @(negedge clk);
            data = 8'h00; @(negedge clk);
            data = 8'h12; @(negedge clk);
            data = 8'h34; @(negedge clk);

            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd2, 16'h1234, 1'b1);
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
        input [9:0] expected_horiz_count;
        input [15:0] expected_wrdata;
        input expected_write;
        begin
            if (expected_horiz_count === (expected_horiz_count ^ horiz_count ^ expected_horiz_count) &&
                expected_wrdata === (expected_wrdata ^ wrdata ^ expected_wrdata) &&
                expected_write === (expected_write ^ write ^ expected_write)) begin
                $display("PASS");
                $display("  Outputs: horiz_count=%h, wrdata=%h, write=%b",
                         horiz_count, wrdata, write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: horiz_count=%h, wrdata=%h, write=%b",
                         expected_horiz_count, expected_wrdata, expected_write);
                $display("  Got:      horiz_count=%h, wrdata=%h, write=%b",
                         horiz_count, wrdata, write);
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
        $dumpvars(0,acapture, clk, data, rdclk, horiz_count, wrdata, write);
    end

endmodule
