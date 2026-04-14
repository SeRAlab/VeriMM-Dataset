`timescale 1ns/1ps

module lfsr_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_8bit dut (
        .clk(clk),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            force dut.q = 8'h01;
            #15;
            release dut.q;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h41);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h51);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_8bit Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, q);
    end

endmodule
