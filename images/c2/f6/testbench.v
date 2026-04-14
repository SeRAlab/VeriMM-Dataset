`timescale 1ns/1ps

module counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_3bit dut (
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
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal counting to 3", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify max value 6", test_num);
            reset_dut();
            enable = 1;
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify wrap-around from 6 to 0", test_num);
            reset_dut();
            enable = 1;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable signal control", test_num);
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous reset takes priority over enable/count", test_num);
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple wrap-arounds (Count 15 times)", test_num);
            reset_dut();
            enable = 1;

            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_3bit Testbench");
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
        input [2:0] expected_count;
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
