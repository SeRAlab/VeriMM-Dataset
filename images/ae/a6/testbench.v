`timescale 1ns/1ps

module gray_counter_12_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [11:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_counter_12 dut (
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
        @(negedge clk);
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase%03d: Reset state", test_num);
        reset_dut();

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase%03d: Binary count 1", test_num);
        reset_dut();
        @(negedge clk);

        #1;


        check_outputs(12'h001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning Testcase%03d: Binary count 3", test_num);
        reset_dut();
        repeat(3) @(negedge clk);

        #1;


        check_outputs(12'h002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nRunning Testcase%03d: Binary count 10", test_num);
        reset_dut();
        repeat(10) @(negedge clk);

        #1;


        check_outputs(12'h00F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nRunning Testcase%03d: Binary count 100", test_num);
        reset_dut();
        repeat(100) @(negedge clk);

        #1;


        check_outputs(12'h056);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nRunning Testcase%03d: Binary count 2047", test_num);
        reset_dut();
        repeat(2047) @(negedge clk);

        #1;


        check_outputs(12'h400);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nRunning Testcase%03d: Counter wraparound", test_num);
        reset_dut();
        repeat(4096) @(negedge clk);

        #1;


        check_outputs(12'h000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_counter_12 Testbench");
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
        input [11:0] expected_Q;
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
