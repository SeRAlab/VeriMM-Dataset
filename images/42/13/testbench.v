`timescale 1ns/1ps

module counter_up_down_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg en;
    reg up_down;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_up_down dut (
        .clear(clear),
        .clk(clk),
        .en(en),
        .up_down(up_down),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clear = 1;
        en = 0;
        up_down = 0;
        @(posedge clk);
        #1;
        clear = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Synchronous Clear", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Counting Up (5 cycles)", test_num);
        reset_dut();
        en = 1;
        up_down = 1;
        repeat (5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Counting Down from Zero (Wrap-around)", test_num);
        reset_dut();
        en = 1;
        up_down = 0;
        repeat (1) @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Enable functionality (Hold)", test_num);
        reset_dut();
        en = 1;
        up_down = 1;
        repeat (3) @(posedge clk);
        #1;
        en = 0;
        repeat (5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Clear Priority over Enable/Up", test_num);
        reset_dut();
        en = 1;
        up_down = 1;
        repeat (10) @(posedge clk);
        #1;
        clear = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Direction Switching", test_num);
        reset_dut();
        en = 1;
        up_down = 1;
        repeat (10) @(posedge clk);
        #1;
        up_down = 0;
        repeat (4) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Overflow Wrap-around", test_num);
        reset_dut();
        en = 1;
        up_down = 1;


        repeat (257) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_up_down Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,clear, clk, en, up_down, Q);
    end

endmodule
