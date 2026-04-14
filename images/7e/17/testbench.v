`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [99:0] sorted_array;
    reg [7:0] target;
    wire [6:0] index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .sorted_array(sorted_array),
        .target(target),
        .index(index)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            target = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task init_array;

        begin
            for (i = 0; i < 100; i = i + 1) begin
                sorted_array[i*8 +: 8] = (i + 1) * 2;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            init_array();
            target = 8'd2;
            repeat(15) @(posedge clk);
            $display("Test %0d: Search for first element (2)", test_num);
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            init_array();
            target = 8'd200;
            repeat(15) @(posedge clk);
            $display("Test %0d: Search for last element (200)", test_num);
            #1;

            check_outputs(7'd99);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            init_array();
            target = 8'd100;
            repeat(15) @(posedge clk);
            $display("Test %0d: Search for middle element (100)", test_num);
            #1;

            check_outputs(7'd49);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            init_array();
            target = 8'd1;
            repeat(15) @(posedge clk);
            $display("Test %0d: Search for non-existent low value (1)", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            init_array();
            target = 8'd250;
            repeat(15) @(posedge clk);
            $display("Test %0d: Search for non-existent high value (250)", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            init_array();
            target = 8'd5;
            repeat(15) @(posedge clk);
            $display("Test %0d: Search for non-existent value in gap (5)", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            init_array();
            target = 8'd100;
            repeat(3) @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            repeat(15) @(posedge clk);
            $display("Test %0d: Search after mid-operation reset", test_num);
            #1;

            check_outputs(7'd49);
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
        testcase007();
        
        
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
        input [6:0] expected_index;
        begin
            if (expected_index === (expected_index ^ index ^ expected_index)) begin
                $display("PASS");
                $display("  Outputs: index=%h",
                         index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: index=%h",
                         expected_index);
                $display("  Got:      index=%h",
                         index);
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
        $dumpvars(0,clk, rst, sorted_array, target, index);
    end

endmodule
