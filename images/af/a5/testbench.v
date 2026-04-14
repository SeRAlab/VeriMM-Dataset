`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg reset;
    wire [7:0] rnd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .reset(reset),
        .rnd(rnd)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset Value Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Enable Control Check", test_num);
            reset_dut();

            enable = 0;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 8-Cycle Generation Check", test_num);
            reset_dut();

            enable = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clock);
            end
            enable = 0;
            #1;




            #1;





            check_outputs(8'h5F);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Discontinuous Enable Check", test_num);
            reset_dut();


            enable = 1;
            repeat(4) @(posedge clock);


            enable = 0;
            repeat(4) @(posedge clock);


            enable = 1;
            repeat(4) @(posedge clock);

            enable = 0;
            #1;


            #1;



            check_outputs(8'h5F);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 16-Cycle Continuity Check", test_num);
            reset_dut();

            enable = 1;
            repeat(16) @(posedge clock);
            enable = 0;
            #1;


            #1;



            check_outputs(8'h01);
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
        input [7:0] expected_rnd;
        begin
            if (expected_rnd === (expected_rnd ^ rnd ^ expected_rnd)) begin
                $display("PASS");
                $display("  Outputs: rnd=%h",
                         rnd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rnd=%h",
                         expected_rnd);
                $display("  Got:      rnd=%h",
                         rnd);
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
        $dumpvars(0,clock, enable, reset, rnd);
    end

endmodule
