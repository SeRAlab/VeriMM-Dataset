`timescale 1ns/1ps

module binary_counter_with_enable_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_with_enable dut (
        .clear(clear),
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 0;
            #12;
            clear = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Incrementing to 5", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            #2;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Enable/Disable Logic", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (3) @(posedge clk);
            enable = 0;
            repeat (3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Roll-over (15 to 0)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (16) @(posedge clk);
            enable = 0;
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Asynchronous Clear", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (7) @(posedge clk);
            #3;
            clear = 1;
            #1;
            #1;

            check_outputs(4'd0);
            clear = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to Maximum Value (15)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (15) @(posedge clk);
            enable = 0;
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_with_enable Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clear, clk, enable, count);
    end

endmodule
