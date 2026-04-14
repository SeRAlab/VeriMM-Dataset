`timescale 1ns/1ps

module freq_divider_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] N;
    reg clk;
    reg enable;
    wire divided_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    freq_divider dut (
        .N(N),
        .clk(clk),
        .enable(enable),
        .divided_clk(divided_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1'b0;
            N = 4'd0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: N=1, check output after 1st toggle");
            test_num = test_num + 1;
            reset_dut();
            N = 4'd1;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: N=2, check output after 2 rising edges");
            test_num = test_num + 1;
            reset_dut();
            N = 4'd2;
            enable = 1'b1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: N=4, check output after 4 rising edges");
            test_num = test_num + 1;
            reset_dut();
            N = 4'd4;
            enable = 1'b1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: N=1, check output after 2 rising edges");
            test_num = test_num + 1;
            reset_dut();
            N = 4'd1;
            enable = 1'b1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: N=2, check output after 4 rising edges");
            test_num = test_num + 1;
            reset_dut();
            N = 4'd2;
            enable = 1'b1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Enable=0, check output remains constant");
            test_num = test_num + 1;
            reset_dut();
            N = 4'd2;
            enable = 1'b0;
            repeat(6) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: N=15, check output after 15 rising edges");
            test_num = test_num + 1;
            reset_dut();
            N = 4'd15;
            enable = 1'b1;
            repeat(15) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("freq_divider Testbench");
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
        input expected_divided_clk;
        begin
            if (expected_divided_clk === (expected_divided_clk ^ divided_clk ^ expected_divided_clk)) begin
                $display("PASS");
                $display("  Outputs: divided_clk=%b",
                         divided_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divided_clk=%b",
                         expected_divided_clk);
                $display("  Got:      divided_clk=%b",
                         divided_clk);
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
        $dumpvars(0,N, clk, enable, divided_clk);
    end

endmodule
