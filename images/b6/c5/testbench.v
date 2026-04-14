`timescale 1ns/1ps

module JC_counter_128_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [127:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JC_counter_128 dut (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: After 1 clock cycle (Expect MSB=1)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h80000000000000000000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: After 64 clock cycles (Half 1s, Half 0s)", test_num);
            reset_dut();
            repeat(64) @(posedge clk);
            #1;
            #1;

            check_outputs(128'hffffffffffffffff0000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: After 128 clock cycles (All 1s)", test_num);
            reset_dut();
            repeat(128) @(posedge clk);
            #1;
            #1;

            check_outputs(128'hffffffffffffffffffffffffffffffff);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: After 129 clock cycles (Transition to 0s)", test_num);
            reset_dut();
            repeat(129) @(posedge clk);
            #1;
            #1;

            check_outputs(128'h7fffffffffffffffffffffffffffffff);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: After 192 clock cycles (Half 0s, Half 1s)", test_num);
            reset_dut();
            repeat(192) @(posedge clk);
            #1;
            #1;

            check_outputs(128'h0000000000000000ffffffffffffffff);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: After 256 clock cycles (Back to all 0s)", test_num);
            reset_dut();
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %03d: After 257 clock cycles (Wrap around start)", test_num);
            reset_dut();
            repeat(257) @(posedge clk);
            #1;
            #1;

            check_outputs(128'h80000000000000000000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JC_counter_128 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [127:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, rst_n, Q);
    end

endmodule
