`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg en;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .areset(areset),
        .clk(clk),
        .en(en),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            en = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying initial reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(12'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying enable low (freeze)...", test_num);
            reset_dut();
            en = 0;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(12'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying single shift step...", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(12'h003);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying sequence progression (3 steps)...", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(12'h00F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying async reset during operation...", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #3;
            areset = 1;
            #1;
            #1;

            check_outputs(12'h001);
            areset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [11:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,areset, clk, en, count);
    end

endmodule
