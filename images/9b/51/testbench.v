`timescale 1ns/1ps

module down_counter_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter_12bit dut (
        .clk(clk),
        .en(en),
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
        en = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single decrement wrap-around (0 -> FFF)", test_num);
        reset_dut();
        en = 1;
        @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple decrements (Decrement 5 times)", test_num);
        reset_dut();
        en = 1;
        repeat(5) @(posedge clk);
        #1;
        en = 0;

        #1;


        check_outputs(12'hFFB);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable control (Counter should pause when en=0)", test_num);
        reset_dut();
        en = 1;
        repeat(3) @(posedge clk);
        en = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(12'hFFD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous reset mid-count", test_num);
        reset_dut();
        en = 1;
        repeat(10) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        en = 0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rollover test (4096 cycles)", test_num);
        reset_dut();
        en = 1;
        repeat(4096) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Count to specific value (256 steps)", test_num);
        reset_dut();
        en = 1;
        repeat(256) @(posedge clk);
        #1;
        en = 0;
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
        $display("down_counter_12bit Testbench");
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
        $dumpvars(0,clk, en, rst, q);
    end

endmodule
