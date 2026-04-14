`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg reset;
    wire detected;
    wire [1:0] index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .detected(detected),
        .index(index)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full sequence 0x12345678", test_num);
            reset_dut();

            @(negedge clk) data = 8'h12;
            @(negedge clk) data = 8'h34;
            @(negedge clk) data = 8'h56;
            @(negedge clk) data = 8'h78;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Incomplete sequence 0x123400", test_num);
            reset_dut();

            @(negedge clk) data = 8'h12;
            @(negedge clk) data = 8'h34;
            @(negedge clk) data = 8'h00;
            @(negedge clk) data = 8'h78;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Noise before valid sequence", test_num);
            reset_dut();

            @(negedge clk) data = 8'hFF;
            @(negedge clk) data = 8'hAA;
            @(negedge clk) data = 8'h12;
            @(negedge clk) data = 8'h34;
            @(negedge clk) data = 8'h56;
            @(negedge clk) data = 8'h78;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during sequence", test_num);
            reset_dut();

            @(negedge clk) data = 8'h12;
            @(negedge clk) data = 8'h34;
            @(negedge clk) reset = 1;
            @(negedge clk) reset = 0; data = 8'h56;
            @(negedge clk) data = 8'h78;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Back-to-back detection", test_num);
            reset_dut();


            @(negedge clk) data = 8'h12;
            @(negedge clk) data = 8'h34;
            @(negedge clk) data = 8'h56;
            @(negedge clk) data = 8'h78;
            @(posedge clk);


            @(negedge clk) data = 8'h12;
            @(negedge clk) data = 8'h34;
            @(negedge clk) data = 8'h56;
            @(negedge clk) data = 8'h78;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'd3);
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
        input expected_detected;
        input [1:0] expected_index;
        begin
            if (expected_detected === (expected_detected ^ detected ^ expected_detected) &&
                expected_index === (expected_index ^ index ^ expected_index)) begin
                $display("PASS");
                $display("  Outputs: detected=%b, index=%h",
                         detected, index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected=%b, index=%h",
                         expected_detected, expected_index);
                $display("  Got:      detected=%b, index=%h",
                         detected, index);
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
        $dumpvars(0,clk, data, reset, detected, index);
    end

endmodule
