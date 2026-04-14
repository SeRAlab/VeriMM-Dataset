`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_60mhz;
    wire [5:0] led;
    wire [1:0] user_io;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_60mhz(clk_60mhz),
        .led(led),
        .user_io(user_io)
    );

    // Clock generation (10ns period)
    initial begin
        clk_60mhz = 0;
        forever #5 clk_60mhz = ~clk_60mhz;
    end

        task reset_dut;

        begin
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(6'b111110, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: After 1 clock cycle", test_num);
            @(posedge clk_60mhz);
            #1;
            #1;

            check_outputs(6'b111110, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: After 3 clock cycles", test_num);
            repeat(2) @(posedge clk_60mhz);
            #1;
            #1;

            check_outputs(6'b111110, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: LED MSB Change (Counter=4)", test_num);
            @(posedge clk_60mhz);
            #1;
            #1;

            check_outputs(6'b111100, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Full counter wrap-around", test_num);
            repeat(124) @(posedge clk_60mhz);
            #1;
            #1;

            check_outputs(6'b111110, 2'b00);
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
        input [5:0] expected_led;
        input [1:0] expected_user_io;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led) &&
                expected_user_io === (expected_user_io ^ user_io ^ expected_user_io)) begin
                $display("PASS");
                $display("  Outputs: led=%h, user_io=%h",
                         led, user_io);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h, user_io=%h",
                         expected_led, expected_user_io);
                $display("  Got:      led=%h, user_io=%h",
                         led, user_io);
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
        $dumpvars(0,clk_60mhz, led, user_io);
    end

endmodule
