`timescale 1ns/1ps

module temperature_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] temp;
    wire shutdown;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_shutdown dut (
        .clk(clk),
        .rst(rst),
        .temp(temp),
        .shutdown(shutdown)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            temp = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature below threshold", test_num);
            reset_dut();
            temp = 70;
            repeat (10) @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature exactly at threshold", test_num);
            reset_dut();
            temp = 75;
            repeat (10) @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature above threshold for 4 cycles", test_num);
            reset_dut();
            temp = 80;
            repeat (4) @(negedge clk);
            temp = 70;
            @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature above threshold for exactly 5 cycles", test_num);
            reset_dut();
            temp = 80;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupted high temperature sequence", test_num);
            reset_dut();
            temp = 85;
            repeat (3) @(negedge clk);
            temp = 20;
            @(negedge clk);
            temp = 85;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset after shutdown", test_num);
            reset_dut();
            temp = 90;
            repeat (6) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fluctuating temperature above threshold", test_num);
            reset_dut();
            temp = 76; @(negedge clk);
            temp = 80; @(negedge clk);
            temp = 100; @(negedge clk);
            temp = 77; @(negedge clk);
            temp = 99; @(negedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_shutdown Testbench");
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
        input expected_shutdown;
        begin
            if (expected_shutdown === (expected_shutdown ^ shutdown ^ expected_shutdown)) begin
                $display("PASS");
                $display("  Outputs: shutdown=%b",
                         shutdown);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown=%b",
                         expected_shutdown);
                $display("  Got:      shutdown=%b",
                         shutdown);
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
        $dumpvars(0,clk, rst, temp, shutdown);
    end

endmodule
