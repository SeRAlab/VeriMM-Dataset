`timescale 1ns/1ps

module prng_lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [6:0] prng;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    prng_lfsr dut (
        .clk(clk),
        .reset(reset),
        .prng(prng)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking reset value...", test_num);
            reset_dut();

            #1;


            check_outputs(7'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking value after 1 clock cycle...", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking value after 5 clock cycles...", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(7'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking value after 7 clock cycles (feedback trigger)...", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #1;



            #1;




            check_outputs(7'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify reset works after multiple cycles...", test_num);
            reset_dut();
            repeat(50) @(posedge clk);
            reset_dut();

            #1;


            check_outputs(7'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("prng_lfsr Testbench");
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
        input [6:0] expected_prng;
        begin
            if (expected_prng === (expected_prng ^ prng ^ expected_prng)) begin
                $display("PASS");
                $display("  Outputs: prng=%h",
                         prng);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prng=%h",
                         expected_prng);
                $display("  Got:      prng=%h",
                         prng);
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
        $dumpvars(0,clk, reset, prng);
    end

endmodule
