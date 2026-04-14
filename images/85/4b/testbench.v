`timescale 1ns/1ps

module sync_set_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg set;
    reg [7:0] set_value;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_set_counter dut (
        .clk(clk),
        .enable(enable),
        .set(set),
        .set_value(set_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        set = 1;
        set_value = 8'h00;
        enable = 0;
        @(posedge clk);
        #1;
        set = 0;
        set_value = 8'h00;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        enable = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        set = 1;
        set_value = 8'hA5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        set = 1;
        set_value = 8'h55;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        enable = 1;
        repeat(5) @(posedge clk);
        enable = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        set = 1;
        set_value = 8'hFF;
        @(posedge clk);
        #1;
        set = 0;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        set = 1;
        set_value = 8'h10;
        @(posedge clk);
        #1;
        set = 0;
        enable = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h13);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_set_counter Testbench");
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
        $dumpvars(0,clk, enable, set, set_value, count);
    end

endmodule
