`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [15:0] count;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count),
        .overflow(overflow)
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
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 100-cycle count increment", test_num);
            reset_dut();
            enable = 1;
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd100, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable/Disable verification", test_num);
            reset_dut();
            enable = 1;
            repeat(50) @(posedge clk);
            enable = 0;
            repeat(50) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd50, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Maximum value and Overflow check", test_num);
            reset_dut();
            enable = 1;
            repeat(65535) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Rollover to zero", test_num);
            reset_dut();
            enable = 1;
            repeat(65536) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            enable = 1;
            repeat(1000) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input [15:0] expected_count;
        input expected_overflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, overflow=%b",
                         count, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, overflow=%b",
                         expected_count, expected_overflow);
                $display("  Got:      count=%h, overflow=%b",
                         count, overflow);
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
        $dumpvars(0,clk, enable, reset, count, overflow);
    end

endmodule
