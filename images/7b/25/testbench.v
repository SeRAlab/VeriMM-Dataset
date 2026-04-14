`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg [63:0] t1_a;
    reg [63:0] t1_b;
    wire [63:0] t6_res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .t1_a(t1_a),
        .t1_b(t1_b),
        .t6_res(t6_res)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            t1_a <= 64'h0;
            t1_b <= 64'h0;

            repeat(5) @(posedge ck);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Basic Addition (5 + 10)", test_num);
            reset_dut();
            @(posedge ck);
            t1_a <= 64'd5;
            t1_b <= 64'd10;

            repeat(5) @(posedge ck);
            #1;
            #1;

            check_outputs(64'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Max Value Overflow", test_num);
            reset_dut();
            @(posedge ck);
            t1_a <= 64'hFFFFFFFFFFFFFFFF;
            t1_b <= 64'h0000000000000001;
            repeat(5) @(posedge ck);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Zero Addition", test_num);
            reset_dut();
            @(posedge ck);
            t1_a <= 64'h0;
            t1_b <= 64'h0;
            repeat(5) @(posedge ck);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Alternating Bits", test_num);
            reset_dut();
            @(posedge ck);
            t1_a <= 64'hAAAAAAAAAAAAAAAA;
            t1_b <= 64'h5555555555555555;
            repeat(5) @(posedge ck);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Large Hex Values", test_num);
            reset_dut();
            @(posedge ck);
            t1_a <= 64'h123456789ABCDEF0;
            t1_b <= 64'h1111111111111111;
            repeat(5) @(posedge ck);
            #1;
            #1;

            check_outputs(64'h23456789ABCDF001);
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
        input [63:0] expected_t6_res;
        begin
            if (expected_t6_res === (expected_t6_res ^ t6_res ^ expected_t6_res)) begin
                $display("PASS");
                $display("  Outputs: t6_res=%h",
                         t6_res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: t6_res=%h",
                         expected_t6_res);
                $display("  Got:      t6_res=%h",
                         t6_res);
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
        $dumpvars(0,ck, t1_a, t1_b, t6_res);
    end

endmodule
