`timescale 1ns/1ps

module up_counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [7:0] load_value;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter_with_load dut (
        .clk(clk),
        .enable(enable),
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
        enable = 0;
        load = 0;
        load_value = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Verifying Reset");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Counting Up (10 cycles)");
        reset_dut();
        enable = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Load Value");
        reset_dut();
        load = 1;
        load_value = 8'hA5;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Enable/Disable Toggle");
        reset_dut();
        enable = 1;
        repeat(5) @(posedge clk);
        enable = 0;
        repeat(5) @(posedge clk);
        enable = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Priority - Reset vs Load");
        reset_dut();
        load = 1;
        load_value = 8'hFF;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        load = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        $display("testcase006: Priority - Load vs Enable");
        reset_dut();
        load = 1;
        load_value = 8'h77;
        enable = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 0;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase007;

    begin
        $display("testcase007: Counter Rollover (255 to 0)");
        reset_dut();
        load = 1;
        load_value = 8'hFF;
        @(posedge clk);
        load = 0;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter_with_load Testbench");
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, enable, load, load_value, reset, count);
    end

endmodule
