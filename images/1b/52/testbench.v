`timescale 1ns/1ps

module rng_lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] seed;
    wire [3:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rng_lfsr dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .random_number(random_number)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Seed 4'b0001, 1 clock cycle");
            seed = 4'b0001;
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Seed 4'b0001, 4 clock cycles");
            seed = 4'b0001;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Seed 4'b1111, 1 clock cycle");
            seed = 4'b1111;
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Seed 4'b1010, 2 clock cycles");
            seed = 4'b1010;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Seed 4'b0000 (Lock-up state)");
            seed = 4'b0000;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Seed 4'b0001, 15 clock cycles (Full Period)");
            seed = 4'b0001;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rng_lfsr Testbench");
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
        input [3:0] expected_random_number;
        begin
            if (expected_random_number === (expected_random_number ^ random_number ^ expected_random_number)) begin
                $display("PASS");
                $display("  Outputs: random_number=%h",
                         random_number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_number=%h",
                         expected_random_number);
                $display("  Got:      random_number=%h",
                         random_number);
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
        $dumpvars(0,clk, rst, seed, random_number);
    end

endmodule
