`timescale 1ns/1ps

module sync_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] load_val;
    reg rst;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_counter dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            load_val = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and single increment");
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load value 4'hA");
            reset_dut();
            load = 1;
            load_val = 4'hA;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load 4'h5 and increment");
            reset_dut();
            load = 1;
            load_val = 4'h5;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Rollover from 15 to 0");
            reset_dut();
            load = 1;
            load_val = 4'hF;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset priority over Load");
            reset_dut();
            load = 1;
            load_val = 4'h7;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            load = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple increments");
            reset_dut();

            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(4'd10);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load 0 and increment");
            reset_dut();
            load = 1;
            load_val = 4'h0;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_counter Testbench");
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
        $dumpvars(0,clk, load, load_val, rst, count);
    end

endmodule
