`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_fsd;
    reg package_complete;
    reg pie_code;
    reg rst_n;
    wire sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_fsd(clk_fsd),
        .package_complete(package_complete),
        .pie_code(pie_code),
        .rst_n(rst_n),
        .sync(sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk_fsd = 0;
        forever #5 clk_fsd = ~clk_fsd;
    end

        task reset_dut;

        begin
            rst_n = 0;
            package_complete = 0;
            pie_code = 1;
            repeat(2) @(posedge clk_fsd);
            #1 rst_n = 1;
            @(posedge clk_fsd);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Normal Detection (0->1)");
            test_num = 2;
            reset_dut();


            pie_code = 0;
            @(posedge clk_fsd);
            #1;


            pie_code = 1;
            @(posedge clk_fsd);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequence Detection followed by package_complete");
            test_num = 3;
            reset_dut();


            pie_code = 0;
            @(posedge clk_fsd);
            #1;


            pie_code = 1;
            @(posedge clk_fsd);
            #1;


            package_complete = 1;
            @(posedge clk_fsd);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Input 1 in Idle");
            test_num = 4;
            reset_dut();


            pie_code = 1;
            @(posedge clk_fsd);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Extended 0 in got0");
            test_num = 5;
            reset_dut();


            pie_code = 0;
            @(posedge clk_fsd);
            #1;


            repeat(3) @(posedge clk_fsd);
            #1;


            pie_code = 1;
            @(posedge clk_fsd);
            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_sync;
        begin
            if (expected_sync === (expected_sync ^ sync ^ expected_sync)) begin
                $display("PASS");
                $display("  Outputs: sync=%b",
                         sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync=%b",
                         expected_sync);
                $display("  Got:      sync=%b",
                         sync);
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
        $dumpvars(0,clk_fsd, package_complete, pie_code, rst_n, sync);
    end

endmodule
