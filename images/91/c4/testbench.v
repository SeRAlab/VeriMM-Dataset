`timescale 1ns/1ps

module counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] load_value;
    reg rst_n;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_load dut (
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
        load_value = 4'h0;
        @(posedge clk);
        #1 rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous load check", test_num);
        reset_dut();
        @(posedge clk);
        load = 1;
        load_value = 4'hA;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Increment check (5 cycles)", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load then increment check", test_num);
        reset_dut();
        @(posedge clk);
        load = 1;
        load_value = 4'h7;
        @(posedge clk);
        #1;
        load = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Wrap-around check", test_num);
        reset_dut();
        @(posedge clk);
        load = 1;
        load_value = 4'hF;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_with_load Testbench");
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
        $dumpvars(0,clk, load, load_value, rst_n, count);
    end

endmodule
