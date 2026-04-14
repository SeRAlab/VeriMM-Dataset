`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] buttons;
    reg clk;
    reg reset;
    wire [3:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .buttons(buttons),
        .clk(clk),
        .reset(reset),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        buttons = 4'b0000;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Executing Testcase %0d: Reset behavior", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Executing Testcase %0d: Single button persistence", test_num);
        reset_dut();
        @(posedge clk);
        buttons = 4'b0001;
        @(posedge clk);
        buttons = 4'b0000;
        @(posedge clk);

        #1;


        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Executing Testcase %0d: Multiple simultaneous buttons", test_num);
        reset_dut();
        @(posedge clk);
        buttons = 4'b1010;
        @(posedge clk);
        buttons = 4'b0000;
        @(posedge clk);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Executing Testcase %0d: Cumulative button presses", test_num);
        reset_dut();
        @(posedge clk);
        buttons = 4'b0010;
        @(posedge clk);
        buttons = 4'b0000;
        @(posedge clk);
        buttons = 4'b0100;
        @(posedge clk);
        buttons = 4'b0000;
        @(posedge clk);

        #1;


        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Executing Testcase %0d: All buttons active", test_num);
        reset_dut();
        @(posedge clk);
        buttons = 4'b1111;
        @(posedge clk);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Executing Testcase %0d: Reset clearing state", test_num);
        reset_dut();
        @(posedge clk);
        buttons = 4'b1111;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_leds;
        begin
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
        $dumpvars(0,buttons, clk, reset, leds);
    end

endmodule
