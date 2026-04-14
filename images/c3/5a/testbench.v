`timescale 1ns/1ps

module clock_delay_inverter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] delay;
    wire clk_delayed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_delay_inverter dut (
        .clk(clk),
        .delay(delay),
        .clk_delayed(clk_delayed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            delay = 4'd1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Delay 1 cycle - Checking High Phase", test_num);
            reset_dut();
            delay = 4'd1;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Delay 1 cycle - Checking Low Phase", test_num);
            reset_dut();
            delay = 4'd1;
            repeat(5) @(negedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Delay 5 cycles", test_num);
            reset_dut();
            delay = 4'd5;
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Delay 10 cycles", test_num);
            reset_dut();
            delay = 4'd10;
            repeat(15) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Delay 3 cycles - Checking Low Phase", test_num);
            reset_dut();
            delay = 4'd3;
            repeat(8) @(negedge clk);
            #2;
            #1;

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
        $display("clock_delay_inverter Testbench");
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
        input expected_clk_delayed;
        begin
            if (expected_clk_delayed === (expected_clk_delayed ^ clk_delayed ^ expected_clk_delayed)) begin
                $display("PASS");
                $display("  Outputs: clk_delayed=%b",
                         clk_delayed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_delayed=%b",
                         expected_clk_delayed);
                $display("  Got:      clk_delayed=%b",
                         clk_delayed);
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
        $dumpvars(0,clk, delay, clk_delayed);
    end

endmodule
