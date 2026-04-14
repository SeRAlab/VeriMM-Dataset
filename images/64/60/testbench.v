`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg hundredth_of_second_passed;
    wire [16:0] counter;
    wire tenth_of_second_passed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .hundredth_of_second_passed(hundredth_of_second_passed),
        .counter(counter),
        .tenth_of_second_passed(tenth_of_second_passed)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            hundredth_of_second_passed = 0;
            @(posedge CLK);
            #1 RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(17'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Increment on hundredth_of_second_passed", test_num);
            reset_dut();
            hundredth_of_second_passed = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(17'd1, 1'b0);
            hundredth_of_second_passed = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify tenth_of_second_passed at counter = 2", test_num);
            reset_dut();
            hundredth_of_second_passed = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1;

            #1;


            check_outputs(17'd2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Wrap around check (0->1->2->0)", test_num);
            reset_dut();
            hundredth_of_second_passed = 1;
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(17'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Counter hold when hundredth_of_second_passed is low", test_num);
            reset_dut();
            hundredth_of_second_passed = 1;
            @(posedge CLK);
            hundredth_of_second_passed = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(17'd1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Manual RESET signal mid-count", test_num);
            reset_dut();
            hundredth_of_second_passed = 1;
            @(posedge CLK);
            RESET = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(17'd0, 1'b0);
            RESET = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: tenth_of_second_passed gate check", test_num);
            reset_dut();
            hundredth_of_second_passed = 1;
            @(posedge CLK);
            @(posedge CLK);
            hundredth_of_second_passed = 0;
            #1;
            #1;

            check_outputs(17'd2, 1'b0);
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
        testcase006();
        testcase007();
        
        
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
        input [16:0] expected_counter;
        input expected_tenth_of_second_passed;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_tenth_of_second_passed === (expected_tenth_of_second_passed ^ tenth_of_second_passed ^ expected_tenth_of_second_passed)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, tenth_of_second_passed=%b",
                         counter, tenth_of_second_passed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, tenth_of_second_passed=%b",
                         expected_counter, expected_tenth_of_second_passed);
                $display("  Got:      counter=%h, tenth_of_second_passed=%b",
                         counter, tenth_of_second_passed);
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
        $dumpvars(0,CLK, RESET, hundredth_of_second_passed, counter, tenth_of_second_passed);
    end

endmodule
