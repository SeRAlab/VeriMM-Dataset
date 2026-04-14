`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg jd;
    wire led6_g;
    wire led6_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .jd(jd),
        .led6_g(led6_g),
        .led6_r(led6_r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting/Initializing inputs...");
            jd = 0;



            repeat (10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Red LED update when jd is high", test_num);
            reset_dut();

            jd = 1;

            $display("Simulating %0d cycles... (This may take a moment)", CYCLES_TO_THRESHOLD);
            repeat (CYCLES_TO_THRESHOLD) @(posedge clk);


            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Green LED update when jd is low", test_num);


            jd = 0;




            $display("Simulating cycles for next update...");
            repeat (CYCLES_TO_THRESHOLD * 2) @(posedge clk);

            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check that JD change is not immediate", test_num);
            reset_dut();

            jd = 0;

            repeat (CYCLES_TO_THRESHOLD / 2) @(posedge clk);


            jd = 1;
            repeat (10) @(posedge clk);
            #1;





            if (led6_r == 0) begin
                $display("PASS: Red LED stayed low before threshold.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Red LED updated prematurely.");
                fail_count = fail_count + 1;
            end
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
        input expected_led6_g;
        input expected_led6_r;
        begin
            if (expected_led6_g === (expected_led6_g ^ led6_g ^ expected_led6_g) &&
                expected_led6_r === (expected_led6_r ^ led6_r ^ expected_led6_r)) begin
                $display("PASS");
                $display("  Outputs: led6_g=%b, led6_r=%b",
                         led6_g, led6_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led6_g=%b, led6_r=%b",
                         expected_led6_g, expected_led6_r);
                $display("  Got:      led6_g=%b, led6_r=%b",
                         led6_g, led6_r);
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
        $dumpvars(0,clk, jd, led6_g, led6_r);
    end

endmodule
