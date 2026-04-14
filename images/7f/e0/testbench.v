`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop_en;
    reg push_en;
    reg [15:0] pushd;
    reg rst;
    wire [15:0] top;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pop_en(pop_en),
        .push_en(push_en),
        .pushd(pushd),
        .rst(rst),
        .top(top)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push_en = 0;
            pop_en = 0;
            pushd = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task push;

        input [15:0] data;
        begin
            push_en = 1;
            pushd = data;
            @(posedge clk);
            #1;
            push_en = 0;
            pushd = 0;
        end
        endtask

    task pop;

        begin
            pop_en = 1;
            @(posedge clk);
            #1;
            pop_en = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Single Push", test_num);
            reset_dut();
            push(16'hAAAA);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Multiple Pushes", test_num);
            reset_dut();
            push(16'h1111);
            push(16'h2222);
            push(16'h3333);
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Push and Pop", test_num);
            reset_dut();
            push(16'h1234);
            push(16'h5678);
            pop();
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Fill Stack to Max", test_num);
            reset_dut();
            push(16'h1); push(16'h2); push(16'h3); push(16'h4);
            push(16'h5); push(16'h6); push(16'h7); push(16'h8);
            #1;

            check_outputs(16'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Stack Overflow Protection", test_num);
            reset_dut();

            push(16'h1); push(16'h2); push(16'h3); push(16'h4);
            push(16'h5); push(16'h6); push(16'h7); push(16'h8);

            push(16'h9);

            #1;


            check_outputs(16'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Stack Underflow Protection", test_num);
            reset_dut();
            pop();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Pop until Empty", test_num);
            reset_dut();
            push(16'hC0DE);
            push(16'hBEEF);
            pop();
            pop();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Interleaved Operations", test_num);
            reset_dut();
            push(16'hAAAA);
            push(16'hBBBB);
            pop();
            push(16'hCCCC);
            push(16'hDDDD);
            pop();
            #1;

            check_outputs(16'hCCCC);
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
        testcase008();
        testcase009();
        
        
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
        input [15:0] expected_top;
        begin
            if (expected_top === (expected_top ^ top ^ expected_top)) begin
                $display("PASS");
                $display("  Outputs: top=%h",
                         top);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: top=%h",
                         expected_top);
                $display("  Got:      top=%h",
                         top);
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
        $dumpvars(0,clk, pop_en, push_en, pushd, rst, top);
    end

endmodule
