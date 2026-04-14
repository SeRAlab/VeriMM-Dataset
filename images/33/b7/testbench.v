`timescale 1ns/1ps

module timer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg reset;
    reg [31:0] start_value;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_32bit dut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .start_value(start_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        start_value = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Increment (10 cycles)", test_num);
        reset_dut();
        repeat (10) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load Predefined Value", test_num);
        reset_dut();
        start_value = 32'hA5A5A5A5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Increment After Load", test_num);
        reset_dut();
        start_value = 32'h0000FF00;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        repeat (5) @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000FF05);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Maximum Value Wrap-around", test_num);
        reset_dut();
        start_value = 32'hFFFFFFFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset Priority over Load", test_num);
        reset_dut();
        start_value = 32'h12345678;
        load = 1;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        load = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Long Increment Test (100 cycles)", test_num);
        reset_dut();
        repeat (100) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_32bit Testbench");
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
        input [31:0] expected_count;
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
        $dumpvars(0,clk, load, reset, start_value, count);
    end

endmodule
