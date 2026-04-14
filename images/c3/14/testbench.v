`timescale 1ns/1ps

module RNG_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [7:0] rand_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RNG dut (
        .clk(clk),
        .rst(rst),
        .rand_num(rand_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking Initial Reset Seed", test_num);
            reset_dut();

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking Transition After 1 Cycle", test_num);
            reset_dut();
            @(posedge clk);

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking Transition After 2 Cycles", test_num);
            reset_dut();
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking Repeatability After 5 Cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking Feedback Logic (10 Cycles)", test_num);
            reset_dut();
            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'h3A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RNG Testbench");
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
        input [7:0] expected_rand_num;
        begin
            if (expected_rand_num === (expected_rand_num ^ rand_num ^ expected_rand_num)) begin
                $display("PASS");
                $display("  Outputs: rand_num=%h",
                         rand_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rand_num=%h",
                         expected_rand_num);
                $display("  Got:      rand_num=%h",
                         rand_num);
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
        $dumpvars(0,clk, rst, rand_num);
    end

endmodule
