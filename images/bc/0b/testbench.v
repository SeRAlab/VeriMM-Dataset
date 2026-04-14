`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg din;
    wire qout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .din(din),
        .qout(qout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            din <= 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capturing 1 on rising edge", test_num);
            reset_dut();
            din <= 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capturing 0 on rising edge", test_num);
            reset_dut();

            din <= 1;
            @(posedge clock);

            din <= 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify hold logic (Falling edge/No edge)", test_num);
            reset_dut();
            din <= 1;
            @(posedge clock);
            #2;
            din <= 0;
            @(negedge clock);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple clock cycles test", test_num);
            reset_dut();
            din <= 1;
            @(posedge clock);
            din <= 0;
            @(posedge clock);
            din <= 1;
            @(posedge clock);
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
        input expected_qout;
        begin
            if (expected_qout === (expected_qout ^ qout ^ expected_qout)) begin
                $display("PASS");
                $display("  Outputs: qout=%b",
                         qout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qout=%b",
                         expected_qout);
                $display("  Got:      qout=%b",
                         qout);
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
        $dumpvars(0,clock, din, qout);
    end

endmodule
