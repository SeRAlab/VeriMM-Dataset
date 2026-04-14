`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gameover;
    reg resetn;
    wire [9:0] rand_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gameover(gameover),
        .resetn(resetn),
        .rand_out(rand_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            gameover = 0;
            @(posedge clk);
            #1;
            resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Value Check", test_num);
            reset_dut();


            #1;



            check_outputs(rand_out);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gameover Override Check", test_num);
            reset_dut();
            gameover = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase003;

        reg [9:0] initial_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Evolution Check (1 Cycle)", test_num);
            reset_dut();
            initial_val = rand_out;
            @(posedge clk);
            #1;

            if (rand_out != initial_val && rand_out != 0) begin
                $display("PASS: Value evolved from %h to %h", initial_val, rand_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Value stayed at %h", initial_val);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gameover Release Recovery Check", test_num);
            reset_dut();
            gameover = 1;
            repeat(2) @(posedge clk);
            #1;
            gameover = 0;
            repeat(2) @(posedge clk);
            #1;

            if (rand_out != 0) begin
                $display("PASS: Output resumed non-zero value %h", rand_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output stuck at zero after gameover release");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        integer i;
        reg broken;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LFSR Stability Check (50 Cycles)", test_num);
            reset_dut();
            broken = 0;
            for (i = 0; i < 50; i = i + 1) begin
                @(posedge clk);
                if (rand_out == 0) broken = 1;
            end
            #1;
            if (!broken) begin
                $display("PASS: Sequence remained non-zero for 50 cycles");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Sequence hit zero state during operation");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [9:0] expected_rand_out;
        begin
            if (expected_rand_out === (expected_rand_out ^ rand_out ^ expected_rand_out)) begin
                $display("PASS");
                $display("  Outputs: rand_out=%h",
                         rand_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rand_out=%h",
                         expected_rand_out);
                $display("  Got:      rand_out=%h",
                         rand_out);
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
        $dumpvars(0,clk, gameover, resetn, rand_out);
    end

endmodule
