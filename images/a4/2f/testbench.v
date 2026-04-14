`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire D1;
    wire D2;
    wire D3;
    wire D4;
    wire D5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            #0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Checking Initial State", test_num);
            reset_dut();

            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: After 1st rotation", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: After 2nd rotation", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: After 3rd rotation", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: After 4th rotation (Full cycle back to 0001)", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Start of second rotation", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: After 12 total cycles (multiple rotations)", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Final state check (Cycle 13)", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_D1;
        input expected_D2;
        input expected_D3;
        input expected_D4;
        input expected_D5;
        begin
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_D3 === (expected_D3 ^ D3 ^ expected_D3) &&
                expected_D4 === (expected_D4 ^ D4 ^ expected_D4) &&
                expected_D5 === (expected_D5 ^ D5 ^ expected_D5)) begin
                $display("PASS");
                $display("  Outputs: D1=%b, D2=%b, D3=%b, D4=%b, D5=%b",
                         D1, D2, D3, D4, D5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%b, D2=%b, D3=%b, D4=%b, D5=%b",
                         expected_D1, expected_D2, expected_D3, expected_D4, expected_D5);
                $display("  Got:      D1=%b, D2=%b, D3=%b, D4=%b, D5=%b",
                         D1, D2, D3, D4, D5);
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
        $dumpvars(0,clk, D1, D2, D3, D4, D5);
    end

endmodule
