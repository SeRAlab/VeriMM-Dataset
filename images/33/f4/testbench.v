`timescale 1ns/1ps

module CSPRNG_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] seed;
    wire [4:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CSPRNG dut (
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

        input [4:0] s;
        begin
            rst = 1;
            seed = s;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Initial Seed Loading (Seed: 0x01)", test_num);
            reset_dut(5'h01);

            #1;


            check_outputs(5'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Step Transition (Seed: 0x01)", test_num);
            reset_dut(5'h01);
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiple Transitions (4 cycles from Seed 0x01)", test_num);
            reset_dut(5'h01);
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Initial Seed Loading (Seed: 0x1F)", test_num);
            reset_dut(5'h1F);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Step Transition (Seed: 0x1F)", test_num);
            reset_dut(5'h1F);
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1E);
        end
        endtask

    task testcase006;

        reg [4:0] first_run;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Determinism Check", test_num);


            reset_dut(5'h0A);
            repeat(5) @(posedge clk);
            first_run = random_number;


            reset_dut(5'h0A);
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(first_run);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CSPRNG Testbench");
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
        input [4:0] expected_random_number;
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
