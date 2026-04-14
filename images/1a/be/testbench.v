`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg heartbeat;
    reg rst_n;
    reg [3:0] timeout;
    wire reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .enable(enable),
        .heartbeat(heartbeat),
        .rst_n(rst_n),
        .timeout(timeout),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable = 0;
            heartbeat = 0;
            timeout = 4'd0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Timeout", test_num);
            reset_dut();

            enable = 1;
            timeout = 4'd5;
            heartbeat = 0;


            repeat(7) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Heartbeat Prevention", test_num);
            reset_dut();

            enable = 1;
            timeout = 4'd5;


            for (i = 0; i < 5; i = i + 1) begin
                repeat(2) @(posedge clk);
                heartbeat = 1;
                @(posedge clk);
                heartbeat = 0;
            end

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Disabled Timer", test_num);
            reset_dut();

            enable = 0;
            timeout = 4'd4;
            heartbeat = 0;

            repeat(10) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Dynamic Timeout Configuration", test_num);
            reset_dut();

            enable = 1;
            timeout = 4'd10;
            heartbeat = 0;


            repeat(8) @(posedge clk);
            if (reset !== 0) begin
                $display("  Sub-check FAIL: Reset asserted too early");
            end


            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: System Reset Recovery", test_num);
            reset_dut();


            enable = 1;
            timeout = 4'd2;
            repeat(4) @(posedge clk);


            if (reset === 1'b1) begin

                rst_n = 0;
                @(posedge clk);
                rst_n = 1;
                @(posedge clk);
            end else begin
                $display("  Warning: Timeout did not trigger as expected for test 005");
            end

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Heartbeat Clearing Reset", test_num);
            reset_dut();

            enable = 1;
            timeout = 4'd3;
            repeat(5) @(posedge clk);


            @(negedge clk);
            heartbeat = 1;
            @(negedge clk);
            heartbeat = 0;

            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_reset;
        begin
            if (expected_reset === (expected_reset ^ reset ^ expected_reset)) begin
                $display("PASS");
                $display("  Outputs: reset=%b",
                         reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset=%b",
                         expected_reset);
                $display("  Got:      reset=%b",
                         reset);
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
        $dumpvars(0,clk, enable, heartbeat, rst_n, timeout, reset);
    end

endmodule
