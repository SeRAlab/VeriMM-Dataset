`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg out0;
    reg out1;
    reg rst_n;
    wire in_count0;
    wire in_count1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .out0(out0),
        .out1(out1),
        .rst_n(rst_n),
        .in_count0(in_count0),
        .in_count1(in_count1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            out0 = 0;
            out1 = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Reset", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle in_count0 (0->1)", test_num);
            reset_dut();
            @(posedge clk);
            out0 = 1;
            @(posedge clk);
            out0 = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle in_count1 (0->1)", test_num);
            reset_dut();
            @(posedge clk);
            out1 = 1;
            @(posedge clk);
            out1 = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle both (0->1)", test_num);
            reset_dut();
            @(posedge clk);
            out0 = 1;
            out1 = 1;
            @(posedge clk);
            out0 = 0;
            out1 = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Double toggle out0 (0->1->0)", test_num);
            reset_dut();
            @(posedge clk);
            out0 = 1;
            @(posedge clk);
            out0 = 1;
            @(posedge clk);
            out0 = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interleaved transitions", test_num);
            reset_dut();
            @(posedge clk);
            out0 = 1;
            @(posedge clk);
            out0 = 0;
            out1 = 1;
            @(posedge clk);
            out1 = 0;
            out0 = 1;
            @(posedge clk);
            out0 = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pulse counts (3 for out0, 4 for out1)", test_num);
            reset_dut();

            repeat(3) begin
                @(posedge clk) out0 = 1;
                @(posedge clk) out0 = 0;
            end

            repeat(4) begin
                @(posedge clk) out1 = 1;
                @(posedge clk) out1 = 0;
            end
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Reset mid-operation", test_num);
            reset_dut();
            @(posedge clk);
            out0 = 1;
            out1 = 1;
            @(posedge clk);

            #2 rst_n = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
            rst_n = 1;
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
        input expected_in_count0;
        input expected_in_count1;
        begin
            if (expected_in_count0 === (expected_in_count0 ^ in_count0 ^ expected_in_count0) &&
                expected_in_count1 === (expected_in_count1 ^ in_count1 ^ expected_in_count1)) begin
                $display("PASS");
                $display("  Outputs: in_count0=%b, in_count1=%b",
                         in_count0, in_count1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_count0=%b, in_count1=%b",
                         expected_in_count0, expected_in_count1);
                $display("  Got:      in_count0=%b, in_count1=%b",
                         in_count0, in_count1);
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
        $dumpvars(0,clk, out0, out1, rst_n, in_count0, in_count1);
    end

endmodule
