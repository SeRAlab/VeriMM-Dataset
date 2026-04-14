`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg indata;
    wire outdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .indata(indata),
        .outdata(outdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            indata = 0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Register Logic High", test_num);
            reset_dut();


            @(negedge clk);
            indata = 1;


            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Register Logic Low", test_num);
            reset_dut();


            @(negedge clk);
            indata = 1;
            @(posedge clk);


            @(negedge clk);
            indata = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Maintain Value (Stability)", test_num);
            reset_dut();

            @(negedge clk);
            indata = 1;


            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Multi-transition Sequence", test_num);
            reset_dut();

            @(negedge clk); indata = 1;
            @(posedge clk);
            @(negedge clk); indata = 0;
            @(posedge clk);
            @(negedge clk); indata = 0;
            @(posedge clk);
            @(negedge clk); indata = 1;
            @(posedge clk);
            #2;

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
        input expected_outdata;
        begin
            if (expected_outdata === (expected_outdata ^ outdata ^ expected_outdata)) begin
                $display("PASS");
                $display("  Outputs: outdata=%b",
                         outdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outdata=%b",
                         expected_outdata);
                $display("  Got:      outdata=%b",
                         outdata);
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
        $dumpvars(0,clk, indata, outdata);
    end

endmodule
