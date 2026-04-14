`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] data_out_inv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out),
        .data_out_inv(data_out_inv)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 8'h00;

            @(posedge clk);
            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Data 8'hAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Data 8'h55", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'h55, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: All Ones", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Independent Edge Capture", test_num);
            reset_dut();


            data_in = 8'hF0;
            @(posedge clk);

            #2;

            data_in = 8'h0F;
            @(negedge clk);

            #1;

            #1;


            check_outputs(8'hF0, 8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Walking Bit", test_num);
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'h01, 8'hFE);
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
        input [7:0] expected_data_out;
        input [7:0] expected_data_out_inv;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_inv === (expected_data_out_inv ^ data_out_inv ^ expected_data_out_inv)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_out_inv=%h",
                         data_out, data_out_inv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_out_inv=%h",
                         expected_data_out, expected_data_out_inv);
                $display("  Got:      data_out=%h, data_out_inv=%h",
                         data_out, data_out_inv);
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
        $dumpvars(0,clk, data_in, data_out, data_out_inv);
    end

endmodule
