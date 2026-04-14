`timescale 1ns/1ps

module csprng_lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] seed;
    wire [4:0] random_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csprng_lfsr dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .random_out(random_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seed=0x01, Cycles=4", test_num);
            seed = 5'h01;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seed=0x1F, Cycles=3", test_num);
            seed = 5'h1F;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h18);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seed=0x10, Cycles=1", test_num);
            seed = 5'h10;
            reset_dut();
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seed=0x05, Cycles=2", test_num);
            seed = 5'h05;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seed=0x0A, Cycles=5", test_num);
            seed = 5'h0A;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("csprng_lfsr Testbench");
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
        input [4:0] expected_random_out;
        begin
            if (expected_random_out === (expected_random_out ^ random_out ^ expected_random_out)) begin
                $display("PASS");
                $display("  Outputs: random_out=%h",
                         random_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_out=%h",
                         expected_random_out);
                $display("  Got:      random_out=%h",
                         random_out);
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
        $dumpvars(0,clk, reset, seed, random_out);
    end

endmodule
