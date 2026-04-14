`timescale 1ns/1ps

module sync_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_counter dut (
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
        #1 rst = 0;
    end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Increment", test_num);
        reset_dut();
        en = 1;
        wait_cycles(1);
        en = 0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Multiple Increments (10 cycles)", test_num);
        reset_dut();
        en = 1;
        wait_cycles(10);
        en = 0;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Enable/Disable Control", test_num);
        reset_dut();
        en = 1;
        wait_cycles(5);
        en = 0;
        wait_cycles(5);
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Reset Priority", test_num);
        reset_dut();
        en = 1;
        wait_cycles(5);
        rst = 1;
        wait_cycles(1);
        rst = 0;
        en = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Wrap-around (256 cycles)", test_num);
        reset_dut();
        en = 1;
        wait_cycles(256);
        en = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Reach Maximum Value (255)", test_num);
        reset_dut();
        en = 1;
        wait_cycles(255);
        en = 0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_counter Testbench");
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
        input [7:0] expected_q;
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
