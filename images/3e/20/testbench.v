`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    reg [3:0] timeout;
    wire timeout_expired;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .timeout(timeout),
        .timeout_expired(timeout_expired)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            timeout = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Timeout Trigger", test_num);
            reset_dut();

            timeout = 4'd5;
            enable = 1;


            repeat (7) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Prevents Timeout", test_num);
            reset_dut();

            timeout = 4'd8;
            enable = 1;


            repeat (4) @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            repeat (4) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Check", test_num);
            reset_dut();

            timeout = 4'd4;
            enable = 0;


            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery from Expired State", test_num);
            reset_dut();

            timeout = 4'd3;
            enable = 1;


            repeat (5) @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum Timeout Value", test_num);
            reset_dut();

            timeout = 4'd1;
            enable = 1;


            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Timeout Value", test_num);
            reset_dut();

            timeout = 4'd15;
            enable = 1;


            repeat (14) @(posedge clk);
            if (timeout_expired !== 1'b0) begin
                $display("Mid-test check failed: expired too early");
            end


            repeat (3) @(posedge clk);

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
        $display("watchdog_timer Testbench");
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
        input expected_timeout_expired;
        begin
            if (expected_timeout_expired === (expected_timeout_expired ^ timeout_expired ^ expected_timeout_expired)) begin
                $display("PASS");
                $display("  Outputs: timeout_expired=%b",
                         timeout_expired);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout_expired=%b",
                         expected_timeout_expired);
                $display("  Got:      timeout_expired=%b",
                         timeout_expired);
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
        $dumpvars(0,clk, enable, rst, timeout, timeout_expired);
    end

endmodule
