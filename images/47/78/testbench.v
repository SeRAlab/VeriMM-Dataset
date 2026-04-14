`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sig;
    wire [13:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sig(sig),
        .f(f)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sig = 0;
            repeat(5) @(posedge clk);

            sig = 1;
            @(posedge clk);
            sig = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Period = 100 clk cycles", test_num);
            reset_dut();


            sig = 1;
            @(posedge clk);
            sig = 0;


            repeat(100) @(posedge clk);


            sig = 1;
            @(posedge clk);
            sig = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(CONSTANT / 100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Period = 50 clk cycles", test_num);
            reset_dut();


            sig = 1;
            @(posedge clk);
            sig = 0;


            repeat(50) @(posedge clk);


            sig = 1;
            @(posedge clk);
            sig = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(CONSTANT / 50);
        end
        endtask

    task testcase003;

        reg [13:0] previous_f;
        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Period below threshold", test_num);
            reset_dut();


            sig = 1; @(posedge clk); sig = 0;
            repeat(100) @(posedge clk);
            sig = 1; @(posedge clk); sig = 0;
            repeat(2) @(posedge clk);
            previous_f = f;



            sig = 1; @(posedge clk); sig = 0;
            repeat(4) @(posedge clk);
            sig = 1; @(posedge clk); sig = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(previous_f);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Period = 200 clk cycles", test_num);
            reset_dut();

            sig = 1;
            @(posedge clk);
            sig = 0;

            repeat(200) @(posedge clk);

            sig = 1;
            @(posedge clk);
            sig = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(CONSTANT / 200);
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
        input [13:0] expected_f;
        begin
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
        $dumpvars(0,clk, sig, f);
    end

endmodule
