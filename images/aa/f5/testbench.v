`timescale 1ns/1ps

module counter_10bit_down_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_10bit_down dut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow from 0 to 1023", test_num);
            reset_dut();
            @(negedge clk);
            #2;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement 10 times", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk);
            end
            #2;
            #1;

            check_outputs(10'd1014);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full wrap-around (1024 cycles)", test_num);
            reset_dut();
            for (i = 0; i < 1024; i = i + 1) begin
                @(negedge clk);
            end
            #2;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();
            @(negedge clk);
            @(negedge clk);
            @(posedge clk);
            #2;
            rst = 1;
            #1;
            #1;

            check_outputs(10'h000);
            rst = 0;
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement 512 times", test_num);
            reset_dut();
            for (i = 0; i < 512; i = i + 1) begin
                @(negedge clk);
            end
            #2;
            #1;

            check_outputs(10'd512);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_10bit_down Testbench");
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
        input [9:0] expected_count;
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
        $dumpvars(0,clk, rst, count);
    end

endmodule
