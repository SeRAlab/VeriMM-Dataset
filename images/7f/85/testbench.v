`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin



            force dut.count = 8'h01;
            @(negedge clk);
            release dut.count;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Verifying Seed State (Initial)", test_num);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Verifying State after 1 cycle", test_num);
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h03);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %0d: Verifying State after 5 cycles", test_num);
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h3E);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Verifying State after 10 cycles", test_num);
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hC4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %0d: Verifying State after 20 cycles", test_num);
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h88);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        $dumpvars(0,clk, count);
    end

endmodule
