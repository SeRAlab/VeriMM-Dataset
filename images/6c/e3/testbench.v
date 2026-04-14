`timescale 1ns/1ps

module synchronous_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [3:0] value;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    synchronous_counter dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .value(value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin

        @(negedge clk);
        load = 1;
        value = 4'b0000;
        enable = 0;
        @(negedge clk);
        load = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Reset and verify count is 0", test_num);
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Load value 4'hA", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        value = 4'hA;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Enable counting for 5 cycles", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(5) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Verify count holds when enable is low", test_num);
        reset_dut();

        @(negedge clk);
        load = 1; value = 4'h7;
        @(negedge clk);
        load = 0;

        enable = 0;
        repeat(3) @(negedge clk);
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Verify wrap around (15 to 0)", test_num);
        reset_dut();

        @(negedge clk);
        load = 1; value = 4'hF;
        @(negedge clk);
        load = 0;
        enable = 1;
        @(negedge clk);
        enable = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Verify Load priority over Enable", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        value = 4'h3;
        enable = 1;
        @(negedge clk);
        load = 0;
        enable = 0;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Count 20 times (wraps to 4)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(20) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(4'h4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("synchronous_counter Testbench");
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
        $dumpvars(0,clk, enable, load, value, count);
    end

endmodule
