`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg count;
    reg countClock;
    reg load;
    reg [7:0] loadvalue;
    wire [7:0] countout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .countClock(countClock),
        .load(load),
        .loadvalue(loadvalue),
        .countout(countout)
    );

    // Clock generation (10ns period)
    initial begin
        countClock = 0;
        forever #5 countClock = ~countClock;
    end

        task reset_dut;

        begin
            load = 1;
            loadvalue = 8'h00;
            count = 0;
            @(posedge countClock);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            loadvalue = 8'hA5;
            count = 0;
            @(posedge countClock);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            loadvalue = 8'h10;
            @(posedge countClock);
            #1;

            load = 0;
            count = 1;
            @(posedge countClock);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            loadvalue = 8'h55;
            @(posedge countClock);
            #1;

            load = 0;
            count = 0;
            repeat(5) @(posedge countClock);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            loadvalue = 8'h01;
            @(posedge countClock);
            #1;

            load = 0;
            count = 1;
            repeat(2) @(posedge countClock);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            loadvalue = 8'h80;
            @(posedge countClock);
            #1;

            load = 1;
            loadvalue = 8'hEE;
            count = 1;
            @(posedge countClock);
            #1;

            #1;


            check_outputs(8'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            loadvalue = 8'h0A;
            @(posedge countClock);
            #1;

            load = 0;
            count = 1;
            repeat(5) @(posedge countClock);
            #1;
            #1;

            check_outputs(8'h05);
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
        input [7:0] expected_countout;
        begin
            if (expected_countout === (expected_countout ^ countout ^ expected_countout)) begin
                $display("PASS");
                $display("  Outputs: countout=%h",
                         countout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: countout=%h",
                         expected_countout);
                $display("  Got:      countout=%h",
                         countout);
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
        $dumpvars(0,count, countClock, load, loadvalue, countout);
    end

endmodule
