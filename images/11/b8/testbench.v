`timescale 1ns/1ps

module lfsr_csprng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [2:0] random_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_csprng dut (
        .clk(clk),
        .reset(reset),
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
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Initial Seed Check", test_num);
            reset_dut();

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Single Cycle Transition", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Three Cycle Transition", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Five Cycle Transition", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Six Cycle Transition", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Full Cycle (Wrap Around)", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running Testcase %03d: Reset Stability", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            reset_dut();
            #1 #1;
 check_outputs(3'b001);
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
        input [2:0] expected_random_out;
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
        $dumpvars(0,clk, reset, random_out);
    end

endmodule
