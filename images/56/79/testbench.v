`timescale 1ns/1ps

module bcd_counter8bit_tc_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [7:0] q;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bcd_counter8bit_tc dut (
        .clk(clk),
        .rst(rst),
        .q(q),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        @(posedge clk);
        #1 rst = 0;

    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying reset state", test_num);
        reset_dut();
        #1;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying unit digit at 9", test_num);
        reset_dut();
        repeat(9) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h09, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying carry to tens digit (10)", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h10, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying terminal count at 99", test_num);
        reset_dut();
        repeat(99) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h99, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying wrap-around (100 -> 00)", test_num);
        reset_dut();
        repeat(100) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verifying arbitrary value (45)", test_num);
        reset_dut();
        repeat(45) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h45, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bcd_counter8bit_tc Testbench");
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
        input [7:0] expected_q;
        input expected_tc;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: q=%h, tc=%b",
                         q, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, tc=%b",
                         expected_q, expected_tc);
                $display("  Got:      q=%h, tc=%b",
                         q, tc);
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
        $dumpvars(0,clk, rst, q, tc);
    end

endmodule
