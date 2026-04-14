`timescale 1ns/1ps

module counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [1:0] load_value;
    reg reset;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_load dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
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
        load_value = 2'b00;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Counting (0 to 2)", test_num);
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Synchronous Load", test_num);
        reset_dut();
        load = 1;
        load_value = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Counter Rollover", test_num);
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Load then Count", test_num);
        reset_dut();
        load = 1;
        load_value = 2'b01;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_count;
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
        $dumpvars(0,clk, load, load_value, reset, count);
    end

endmodule
