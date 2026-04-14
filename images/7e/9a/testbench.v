`timescale 1ns/1ps

module traffic_light_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire green;
    wire red;
    wire yellow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    traffic_light dut (
        .clk(clk),
        .reset(reset),
        .green(green),
        .red(red),
        .yellow(yellow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset (Red)", test_num);
            reset_dut();
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State after 1 clock cycle (Green)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State after 2 clock cycles (Yellow)", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State after 3 clock cycles (Back to Red)", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State after 4 clock cycles (Second Green cycle)", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-sequence reset check", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            reset_dut();
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("traffic_light Testbench");
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
        input expected_green;
        input expected_red;
        input expected_yellow;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_yellow === (expected_yellow ^ yellow ^ expected_yellow)) begin
                $display("PASS");
                $display("  Outputs: green=%b, red=%b, yellow=%b",
                         green, red, yellow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, red=%b, yellow=%b",
                         expected_green, expected_red, expected_yellow);
                $display("  Got:      green=%b, red=%b, yellow=%b",
                         green, red, yellow);
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
        $dumpvars(0,clk, reset, green, red, yellow);
    end

endmodule
