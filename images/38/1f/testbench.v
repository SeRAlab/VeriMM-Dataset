`timescale 1ns/1ps

module lfsr_csprng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] seed;
    wire [4:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_csprng dut (
        .clk(clk),
        .reset(reset),
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
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x01 initialization check", test_num);
            seed = 5'h01;
            reset_dut();
            #1;
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x01, 1 cycle", test_num);
            seed = 5'h01;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x01, 5 cycles", test_num);
            seed = 5'h01;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x1F, 1 cycle", test_num);
            seed = 5'h1F;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x1F, 3 cycles", test_num);
            seed = 5'h1F;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h19);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x0A, 2 cycles", test_num);
            seed = 5'h0A;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0B);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x10, 1 cycle", test_num);
            seed = 5'h10;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Primitive period check (31 cycles from 0x01)", test_num);
            seed = 5'h01;
            reset_dut();
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_csprng Testbench");
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
        $dumpvars(0,clk, reset, seed, random_number);
    end

endmodule
