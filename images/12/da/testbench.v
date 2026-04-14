`timescale 1ns/1ps

module counter_64bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [63:0] load_value;
    reg rst_n;
    wire [63:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_64bit dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            load_value = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Counting (15 cycles)", test_num);
            reset_dut();

            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(64'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Loading Specific Value", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 64'hA5A5A5A5A5A5A5A5;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(64'hA5A5A5A5A5A5A5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counting After Load", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 64'h00000000FFFFFFF0;
            @(posedge clk);
            #1;
            load = 0;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000FFFFFFF0 + 64'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter Wrap-around", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Async Reset Mid-Operation", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #2;
            rst_n = 0;
            #10;
            #1;

            check_outputs(64'h0);
            rst_n = 1;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Value Handling", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 64'h7FFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h8000000000000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_64bit Testbench");
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
        input [63:0] expected_count;
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
        $dumpvars(0,clk, load, load_value, rst_n, count);
    end

endmodule
