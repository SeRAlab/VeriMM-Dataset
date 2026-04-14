`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg en;
    reg reset_n;
    wire [19:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clear(clear),
        .clk(clk),
        .en(en),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        clear = 0;
        en = 0;
        #15;
        reset_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Asynchronous Reset", test_num);
        reset_dut();

        #1;


        check_outputs(20'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Wrap Around (0 to FFFFF)", test_num);
        reset_dut();
        @(posedge clk);
        en = 1;
        @(posedge clk);
        en = 0;
        #1;
        #1;

        check_outputs(20'hFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying 10 Decrements", test_num);
        reset_dut();
        @(posedge clk);
        en = 1;
        repeat(10) @(posedge clk);
        en = 0;
        #1;

        #1;


        check_outputs(20'hFFFF6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Synchronous Clear", test_num);
        reset_dut();
        @(posedge clk);
        en = 1;
        repeat(5) @(posedge clk);
        clear = 1;
        @(posedge clk);
        clear = 0;
        en = 0;
        #1;
        #1;

        check_outputs(20'h00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Enable Inactive (Hold state)", test_num);
        reset_dut();
        @(posedge clk);
        en = 1;
        repeat(3) @(posedge clk);
        en = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(20'hFFFBD);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Clear priority over Enable", test_num);
        reset_dut();
        @(posedge clk);
        en = 1;
        clear = 1;
        @(posedge clk);
        en = 0;
        clear = 0;
        #1;
        #1;

        check_outputs(20'h00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        input [19:0] expected_q;
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
        $dumpvars(0,clear, clk, en, reset_n, q);
    end

endmodule
