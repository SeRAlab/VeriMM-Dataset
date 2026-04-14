`timescale 1ns/1ps

module CSPRNG_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] num_bits;
    reg reset;
    reg [15:0] seed;
    wire [15:0] random_bits;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CSPRNG dut (
        .clk(clk),
        .num_bits(num_bits),
        .reset(reset),
        .seed(seed),
        .random_bits(random_bits),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            seed = 16'h0;
            num_bits = 5'd0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Start - Seed=0x1234, num_bits=8", test_num);
            reset_dut();

            seed = 16'h1234;
            num_bits = 5'd8;



            wait(ready == 1);
            @(posedge clk);



            #1;




            check_outputs(random_bits, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Full 16-bit Generation - Seed=0xABCD, num_bits=16", test_num);
            reset_dut();

            seed = 16'hABCD;
            num_bits = 5'd16;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(random_bits, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Minimum 1-bit Generation - Seed=0xFFFF, num_bits=1", test_num);
            reset_dut();

            seed = 16'hFFFF;
            num_bits = 5'd1;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(random_bits, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Low Seed Value - Seed=0x0001, num_bits=4", test_num);
            reset_dut();

            seed = 16'h0001;
            num_bits = 5'd4;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(random_bits, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Patterned Seed - Seed=0x5A5A, num_bits=16", test_num);
            reset_dut();

            seed = 16'h5A5A;
            num_bits = 5'd16;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(random_bits, 1'b1);
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
        input [15:0] expected_random_bits;
        input expected_ready;
        begin
            if (expected_random_bits === (expected_random_bits ^ random_bits ^ expected_random_bits) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: random_bits=%h, ready=%b",
                         random_bits, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_bits=%h, ready=%b",
                         expected_random_bits, expected_ready);
                $display("  Got:      random_bits=%h, ready=%b",
                         random_bits, ready);
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
        $dumpvars(0,clk, num_bits, reset, seed, random_bits, ready);
    end

endmodule
