`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg rst;
    reg ssel;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mosi(mosi),
        .rst(rst),
        .ssel(ssel),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ssel = 1;
            mosi = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Transition Cycle", test_num);
            reset_dut();


            ssel = 0;
            mosi = 1;
            @(posedge clk);


            mosi = 0;
            @(posedge clk);


            mosi = 1;
            repeat(2) @(posedge clk);


            ssel = 1;
            @(posedge clk);


            @(posedge clk);


            #1;



            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transfer to Done skipping Receive", test_num);
            reset_dut();

            ssel = 0;
            mosi = 1;
            repeat(3) @(posedge clk);

            ssel = 1;
            @(posedge clk);

            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in IDLE", test_num);
            reset_dut();

            ssel = 1;
            mosi = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Extended Receive Phase", test_num);
            reset_dut();

            ssel = 0;
            @(posedge clk);
            mosi = 0;
            @(posedge clk);


            repeat(8) begin
                mosi = ~mosi;
                @(posedge clk);
            end

            ssel = 1;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(0);
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
        input expected_miso;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: miso=%b",
                         miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b",
                         expected_miso);
                $display("  Got:      miso=%b",
                         miso);
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
        $dumpvars(0,clk, mosi, rst, ssel, miso);
    end

endmodule
