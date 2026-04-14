`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_1;
    reg switch;
    reg times_count;
    wire dig_show;
    wire [9:0] speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_1(clk_1),
        .switch(switch),
        .times_count(times_count),
        .dig_show(dig_show),
        .speed(speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk_1 = 0;
        forever #5 clk_1 = ~clk_1;
    end

        task reset_dut;

        begin
            switch = 0;
            times_count = 0;
            @(posedge clk_1);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Switch Off State", test_num);


            repeat(10) begin
                times_count = 1; #10;
                times_count = 0; #10;
            end

            @(posedge clk_1);
            #1;
            #1;

            check_outputs(1'b0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Speed Calculation", test_num);


            repeat(15) begin
                times_count = 1; #10;
                times_count = 0; #10;
            end

            switch = 1;
            repeat(2) @(posedge clk_1);
            #1;

            #1;


            check_outputs(1'b1, 10'd15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Switch On with Zero Pulses", test_num);

            switch = 1;
            repeat(2) @(posedge clk_1);
            #1;
            #1;

            check_outputs(1'b1, 10'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Differential Calculation", test_num);


            repeat(20) begin
                times_count = 1; #5; times_count = 0; #5;
            end


            switch = 1;
            @(posedge clk_1);
            switch = 0;
            @(posedge clk_1);


            repeat(35) begin
                times_count = 1; #5; times_count = 0; #5;
            end

            switch = 1;
            repeat(2) @(posedge clk_1);
            #1;


            #1;



            check_outputs(1'b1, 10'd35);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Large Count Value", test_num);

            repeat(512) begin
                times_count = 1; #2; times_count = 0; #2;
            end

            switch = 1;
            repeat(2) @(posedge clk_1);
            #1;
            #1;

            check_outputs(1'b1, 10'd512);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_dig_show;
        input [9:0] expected_speed;
        begin
            if (expected_dig_show === (expected_dig_show ^ dig_show ^ expected_dig_show) &&
                expected_speed === (expected_speed ^ speed ^ expected_speed)) begin
                $display("PASS");
                $display("  Outputs: dig_show=%b, speed=%h",
                         dig_show, speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dig_show=%b, speed=%h",
                         expected_dig_show, expected_speed);
                $display("  Got:      dig_show=%b, speed=%h",
                         dig_show, speed);
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
        $dumpvars(0,clk_1, switch, times_count, dig_show, speed);
    end

endmodule
