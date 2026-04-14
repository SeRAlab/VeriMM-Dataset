`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            @(posedge clk);
            #2;
            reset = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 100; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 1000; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();

            for (i = 0; i < 65535; i = i + 1) begin
                @(posedge clk);
            end

            #1;


            check_outputs(16'hFFFF);


            @(posedge clk);

            #1;


            check_outputs(16'h0000);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk, reset);
    end

endmodule
