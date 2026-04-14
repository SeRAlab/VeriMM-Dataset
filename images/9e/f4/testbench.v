`timescale 1ns/1ps

module Counter_12_en_sync_rst_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [11:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Counter_12_en_sync_rst dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        en = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Increment (10 cycles)", test_num);
        reset_dut();
        en = 1;
        repeat(10) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable Toggle Check", test_num);
        reset_dut();
        en = 1;
        repeat(5) @(posedge clk);
        en = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sync Reset Priority Over Enable", test_num);
        reset_dut();
        en = 1;
        repeat(20) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        en = 0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Full Wrap-around Check", test_num);
        reset_dut();
        en = 1;

        repeat(4096) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Intermediate Value (0xABC)", test_num);
        reset_dut();
        en = 1;
        repeat(2748) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(12'hABC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Counter_12_en_sync_rst Testbench");
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
        $dumpvars(0,clk, en, rst, Q);
    end

endmodule
