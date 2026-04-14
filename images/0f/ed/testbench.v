`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start_ch1;
    reg start_ch2;
    reg stop_ch1;
    reg stop_ch2;
    wire busy_ch1;
    wire busy_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .rst(rst),
        .start_ch1(start_ch1),
        .start_ch2(start_ch2),
        .stop_ch1(stop_ch1),
        .stop_ch2(stop_ch2),
        .busy_ch1(busy_ch1),
        .busy_ch2(busy_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start_ch1 = 0;
        start_ch2 = 0;
        stop_ch1 = 0;
        stop_ch2 = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial state after reset", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Start Channel 1", test_num);
        reset_dut();
        start_ch1 = 1;
        @(posedge clk);
        #1;
        start_ch1 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Start and Stop Channel 1", test_num);
        reset_dut();
        start_ch1 = 1;
        @(posedge clk);
        #1;
        start_ch1 = 0;
        stop_ch1 = 1;
        @(posedge clk);
        #1;
        stop_ch1 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Start Channel 2", test_num);
        reset_dut();
        start_ch2 = 1;
        @(posedge clk);
        #1;
        start_ch2 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Start and Stop Channel 2", test_num);
        reset_dut();
        start_ch2 = 1;
        @(posedge clk);
        #1;
        start_ch2 = 0;
        stop_ch2 = 1;
        @(posedge clk);
        #1;
        stop_ch2 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Start both channels simultaneously", test_num);
        reset_dut();
        start_ch1 = 1;
        start_ch2 = 1;
        @(posedge clk);
        #1;
        start_ch1 = 0;
        start_ch2 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Start both, stop only Channel 1", test_num);
        reset_dut();
        start_ch1 = 1;
        start_ch2 = 1;
        @(posedge clk);
        #1;
        start_ch1 = 0;
        start_ch2 = 0;
        stop_ch1 = 1;
        @(posedge clk);
        #1;
        stop_ch1 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Start both, stop both", test_num);
        reset_dut();
        start_ch1 = 1;
        start_ch2 = 1;
        @(posedge clk);
        #1;
        start_ch1 = 0;
        start_ch2 = 0;
        stop_ch1 = 1;
        stop_ch2 = 1;
        @(posedge clk);
        #1;
        stop_ch1 = 0;
        stop_ch2 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Start Ch1 while Ch2 is running", test_num);
        reset_dut();
        start_ch2 = 1;
        @(posedge clk);
        #1;
        start_ch2 = 0;
        start_ch1 = 1;
        @(posedge clk);
        #1;
        start_ch1 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Stop signal when idle", test_num);
        reset_dut();
        stop_ch1 = 1;
        stop_ch2 = 1;
        @(posedge clk);
        #1;
        stop_ch1 = 0;
        stop_ch2 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_busy_ch1;
        input expected_busy_ch2;
        begin
            if (expected_busy_ch1 === (expected_busy_ch1 ^ busy_ch1 ^ expected_busy_ch1) &&
                expected_busy_ch2 === (expected_busy_ch2 ^ busy_ch2 ^ expected_busy_ch2)) begin
                $display("PASS");
                $display("  Outputs: busy_ch1=%b, busy_ch2=%b",
                         busy_ch1, busy_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy_ch1=%b, busy_ch2=%b",
                         expected_busy_ch1, expected_busy_ch2);
                $display("  Got:      busy_ch1=%b, busy_ch2=%b",
                         busy_ch1, busy_ch2);
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
        $dumpvars(0,clk, rst, start_ch1, start_ch2, stop_ch1, stop_ch2, busy_ch1, busy_ch2);
    end

endmodule
