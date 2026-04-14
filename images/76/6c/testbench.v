`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg offset;
    wire [7:0] pointer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .offset(offset),
        .pointer(pointer)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            offset = 0;

            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Increment (offset=0)", test_num);
            reset_dut();


            shadow_pointer = pointer;

            offset = 0;
            repeat(10) begin
                @(posedge clk);
                shadow_pointer = shadow_pointer + 1;
            end

            #2;
            #1;

            check_outputs(shadow_pointer);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Jump Increment (offset=1)", test_num);

            shadow_pointer = pointer;
            offset = 1;

            repeat(5) begin
                @(posedge clk);
                shadow_pointer = shadow_pointer + 2;
            end

            #2;
            #1;

            check_outputs(shadow_pointer);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Offset", test_num);

            shadow_pointer = pointer;


            offset = 0;
            @(posedge clk);
            shadow_pointer = shadow_pointer + 1;


            offset = 1;
            @(posedge clk);
            shadow_pointer = shadow_pointer + 2;


            offset = 0;
            @(posedge clk);
            shadow_pointer = shadow_pointer + 1;

            #2;
            #1;

            check_outputs(shadow_pointer);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Wrap Around Verification", test_num);

            shadow_pointer = pointer;
            offset = 1;


            repeat(150) begin
                @(posedge clk);
                shadow_pointer = shadow_pointer + 2;
            end

            #2;
            #1;

            check_outputs(shadow_pointer);
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
        input [7:0] expected_pointer;
        begin
            if (expected_pointer === (expected_pointer ^ pointer ^ expected_pointer)) begin
                $display("PASS");
                $display("  Outputs: pointer=%h",
                         pointer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pointer=%h",
                         expected_pointer);
                $display("  Got:      pointer=%h",
                         pointer);
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
        $dumpvars(0,clk, offset, pointer);
    end

endmodule
