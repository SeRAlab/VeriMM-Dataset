`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg speed_up;
    wire [3:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .speed_up(speed_up),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            speed_up = 0;
            repeat(5) @(posedge clk);
            rst = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Speed LED Sequence", test_num);
            reset_dut();
            speed_up = 0;

            repeat(100) @(posedge clk);



            if (led !== 4'b0000) begin
                $display("PASS: LEDs progressed at normal speed");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: LEDs stayed at 0 after 100 cycles at normal speed");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        reg [3:0] slow_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Speed Up Mode Comparison", test_num);


            reset_dut();
            speed_up = 0;
            repeat(40) @(posedge clk);
            slow_val = led;


            reset_dut();
            speed_up = 1;
            repeat(40) @(posedge clk);


            if (led > slow_val || (slow_val == 4'b1111 && led == 4'b1111)) begin
                $display("PASS: speed_up reached state %b vs normal state %b", led, slow_val);
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: speed_up did not accelerate sequence (Speed_up: %b, Normal: %b)", led, slow_val);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Sequence Completion", test_num);
            reset_dut();
            speed_up = 1;


            repeat(500) @(posedge clk);

            #1;


            check_outputs(4'b1111);
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
        input [3:0] expected_led;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
        $dumpvars(0,clk, rst, speed_up, led);
    end

endmodule
