`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg [31:0] my_m_value;
    wire new_clock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .my_m_value(my_m_value),
        .new_clock(new_clock)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            my_m_value = 32'd1;
            @(negedge CLOCK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=2, first toggle", test_num);
            my_m_value = 32'd2;
            repeat (2) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=2, second toggle", test_num);
            my_m_value = 32'd2;
            repeat (2) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=5, first toggle", test_num);
            my_m_value = 32'd5;
            repeat (5) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=5, second toggle", test_num);
            my_m_value = 32'd5;
            repeat (5) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=1, first toggle", test_num);
            my_m_value = 32'd1;
            repeat (1) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=1, second toggle", test_num);
            my_m_value = 32'd1;
            repeat (1) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=10, first toggle", test_num);
            my_m_value = 32'd10;
            repeat (10) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=10, second toggle", test_num);
            my_m_value = 32'd10;
            repeat (10) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=100, first toggle", test_num);
            my_m_value = 32'd100;
            repeat (100) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: M=100, second toggle", test_num);
            my_m_value = 32'd100;
            repeat (100) @(posedge CLOCK);
            #1 #1;
 check_outputs(1'b0);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_new_clock;
        begin
            if (expected_new_clock === (expected_new_clock ^ new_clock ^ expected_new_clock)) begin
                $display("PASS");
                $display("  Outputs: new_clock=%b",
                         new_clock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_clock=%b",
                         expected_new_clock);
                $display("  Got:      new_clock=%b",
                         new_clock);
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
        $dumpvars(0,CLOCK, my_m_value, new_clock);
    end

endmodule
