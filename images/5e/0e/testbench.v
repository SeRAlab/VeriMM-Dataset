`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg MID_CLK;
    reg seg_pointer;
    wire anode0;
    wire anode1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MID_CLK(MID_CLK),
        .seg_pointer(seg_pointer),
        .anode0(anode0),
        .anode1(anode1)
    );

    // Clock generation (10ns period)
    initial begin
        MID_CLK = 0;
        forever #5 MID_CLK = ~MID_CLK;
    end

        task reset_dut;

        begin
            seg_pointer = 0;
            @(negedge MID_CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing seg_pointer = 0", test_num);
            reset_dut();

            seg_pointer = 0;
            @(posedge MID_CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing seg_pointer = 1", test_num);
            reset_dut();

            seg_pointer = 1;
            @(posedge MID_CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition 0 -> 1", test_num);
            reset_dut();


            seg_pointer = 0;
            @(posedge MID_CLK);
            #2;


            seg_pointer = 1;
            @(posedge MID_CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition 1 -> 0", test_num);
            reset_dut();


            seg_pointer = 1;
            @(posedge MID_CLK);
            #2;


            seg_pointer = 0;
            @(posedge MID_CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_anode0;
        input expected_anode1;
        begin
            if (expected_anode0 === (expected_anode0 ^ anode0 ^ expected_anode0) &&
                expected_anode1 === (expected_anode1 ^ anode1 ^ expected_anode1)) begin
                $display("PASS");
                $display("  Outputs: anode0=%b, anode1=%b",
                         anode0, anode1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anode0=%b, anode1=%b",
                         expected_anode0, expected_anode1);
                $display("  Got:      anode0=%b, anode1=%b",
                         anode0, anode1);
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
        $dumpvars(0,MID_CLK, seg_pointer, anode0, anode1);
    end

endmodule
