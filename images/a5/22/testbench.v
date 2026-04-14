`timescale 1ns/1ps

module binary_counter_down_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_down dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            enable = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap around from 0 to 0xFFF", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Decrements", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (5) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(12'hFFB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Check", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (3) @(negedge clk);
            enable = 0;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(12'hFFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (10) @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
            enable = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long Duration Count", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (256) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(12'hF00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_down Testbench");
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
        $dumpvars(0,clk, enable, reset, count);
    end

endmodule
