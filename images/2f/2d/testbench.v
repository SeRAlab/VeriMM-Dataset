`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [3:0] start_value;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .start_value(start_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [3:0] val;
        begin
            @(negedge clk);
            start_value = val;
            rst_n = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Start 5, decrement 3 times", test_num);
            reset_dut(4'd5);
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Start 3, count to zero", test_num);
            reset_dut(4'd3);
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Verify counter stays at zero", test_num);
            reset_dut(4'd2);
            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Start at 15, decrement 10 times", test_num);
            reset_dut(4'hf);
            repeat(10) @(posedge clk);

            #1 #1;
 check_outputs(4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Start at 0, verify it stays 0", test_num);
            reset_dut(4'd0);
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
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
        $dumpvars(0,clk, rst_n, start_value, count);
    end

endmodule
