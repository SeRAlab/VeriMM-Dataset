`timescale 1ns/1ps

module counter12bit_even_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter12bit_even dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1 rst = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Checking reset state...");
            reset_dut();

            #1;


            check_outputs(12'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Checking increment to 10 (5 clock cycles)...");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Checking increment to 512 (256 clock cycles)...");
            reset_dut();
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd512);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Checking maximum even value 4094 (2047 clock cycles)...");
            reset_dut();
            repeat(2047) @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Checking wrap-around from 4094 back to 0...");
            reset_dut();
            repeat(2048) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Checking wrap-around and incrementing to 4...");
            reset_dut();
            repeat(2050) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter12bit_even Testbench");
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
        input [11:0] expected_q;
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
        $dumpvars(0,clk, rst, q);
    end

endmodule
