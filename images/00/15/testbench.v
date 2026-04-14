`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [31:0] load_value;
    reg reset;
    wire [31:0] timer_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .timer_value(timer_value)
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
        load_value = 0;
        #7;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying basic counting after reset", test_num);
        reset_dut();

        repeat(9) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying synchronous load", test_num);
        reset_dut();
        load_value = 32'hA5A5A5A5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying counting from a loaded value", test_num);
        reset_dut();
        load_value = 32'h0000_7FFF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_7FFF + 32'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying timer rollover at max value", test_num);
        reset_dut();
        load_value = 32'hFFFF_FFFF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying asynchronous reset priority during count", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #3;
        reset = 1;
        #1;
        #1;

        check_outputs(32'h0000_0000);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verifying load_value is ignored if load signal is low", test_num);
        reset_dut();
        load_value = 32'hDEADBEEF;
        load = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(32'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Verifying back-to-back loads", test_num);
        reset_dut();
        load = 1;
        load_value = 32'h1111_1111;
        @(posedge clk);
        #1;
        load_value = 32'h2222_2222;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(32'h2222_2222);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input [31:0] expected_timer_value;
        begin
            if (expected_timer_value === (expected_timer_value ^ timer_value ^ expected_timer_value)) begin
                $display("PASS");
                $display("  Outputs: timer_value=%h",
                         timer_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_value=%h",
                         expected_timer_value);
                $display("  Got:      timer_value=%h",
                         timer_value);
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
        $dumpvars(0,clk, load, load_value, reset, timer_value);
    end

endmodule
