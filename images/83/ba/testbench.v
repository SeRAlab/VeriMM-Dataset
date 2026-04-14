`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] set_index_i;
    reg [31:0] set_index_j;
    reg [31:0] set_value;
    wire [31:0] get_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .set_index_i(set_index_i),
        .set_index_j(set_index_j),
        .set_value(set_value),
        .get_value(get_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            set_index_i = 0;
            set_index_j = 0;
            set_value = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Writing 32'hA5A5A5A5 to (0,0)", test_num);
            set_index_i = 0;
            set_index_j = 0;
            set_value = 32'hA5A5A5A5;
            reset = 0;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Writing 32'h12345678 to (9,9)", test_num);
            set_index_i = 9;
            set_index_j = 9;
            set_value = 32'h12345678;
            reset = 0;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Resetting specific element (5,5)", test_num);

            set_index_i = 5; set_index_j = 5; set_value = 32'hFFFFFFFF;
            reset = 0;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Checking element independence", test_num);

            set_index_i = 1; set_index_j = 2; set_value = 32'hBEEFCAFE;
            reset = 0;
            @(posedge clk);
            #1;

            set_index_i = 2; set_index_j = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Overwriting value at (4,4)", test_num);
            set_index_i = 4; set_index_j = 4; set_value = 32'h11111111;
            @(posedge clk);
            #1;
            set_value = 32'h22222222;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h22222222);
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
        input [31:0] expected_get_value;
        begin
            if (expected_get_value === (expected_get_value ^ get_value ^ expected_get_value)) begin
                $display("PASS");
                $display("  Outputs: get_value=%h",
                         get_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: get_value=%h",
                         expected_get_value);
                $display("  Got:      get_value=%h",
                         get_value);
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
        $dumpvars(0,clk, reset, set_index_i, set_index_j, set_value, get_value);
    end

endmodule
