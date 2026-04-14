`timescale 1ns/1ps

module CSPRNG_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [4:0] seed;
    wire random_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CSPRNG dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .seed(seed),
        .random_bit(random_bit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            seed = 5'b10101;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial reset check...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 1-cycle generation check...");
            test_num = 2;
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 5-cycle sequence check...");
            test_num = 3;
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            #1;
            enable = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable signal (hold) check...");
            test_num = 4;
            reset_dut();
            enable = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Different seed (00111) check...");
            test_num = 5;
            reset = 1;
            seed = 5'b00111;
            @(posedge clk);
            #1;
            reset = 0;
            enable = 1;
            repeat(2) @(posedge clk);
            #1;
            enable = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Intermittent enable check...");
            test_num = 6;
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_random_bit;
        begin
            if (expected_random_bit === (expected_random_bit ^ random_bit ^ expected_random_bit)) begin
                $display("PASS");
                $display("  Outputs: random_bit=%b",
                         random_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_bit=%b",
                         expected_random_bit);
                $display("  Got:      random_bit=%b",
                         random_bit);
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
        $dumpvars(0,clk, enable, reset, seed, random_bit);
    end

endmodule
