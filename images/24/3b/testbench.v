`timescale 1ns/1ps

module CSPRNG_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] seed;
    wire random_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CSPRNG dut (
        .clk(clk),
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

        input [7:0] seed_val;
        begin
            @(posedge clk);
            reset = 1;
            seed = seed_val;
            @(posedge clk);
            #1;
            reset = 0;
            seed = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Seed 0x01 - Cycle 1", test_num);
            reset_dut(8'h01);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Seed 0x01 - Cycle 2", test_num);
            reset_dut(8'h01);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Seed 0xFF - Cycle 1", test_num);
            reset_dut(8'hFF);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Seed 0xAA - After 3 cycles", test_num);
            reset_dut(8'hAA);
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(random_bit);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Determinism check - Seed 0x01", test_num);
            reset_dut(8'h01);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        $dumpvars(0,clk, reset, seed, random_bit);
    end

endmodule
