`timescale 1ns/1ps

module edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_signal;
    reg rst_n;
    wire falling_edge;
    wire rising_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detector dut (
        .clk(clk),
        .in_signal(in_signal),
        .rst_n(rst_n),
        .falling_edge(falling_edge),
        .rising_edge(rising_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            in_signal = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising Edge Detection", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 0;
            @(negedge clk);
            in_signal = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling Edge Detection", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 1;
            @(negedge clk);
            in_signal = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Steady Low Signal", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 0;
            @(negedge clk);
            in_signal = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Steady High Signal", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 1;
            @(negedge clk);
            @(negedge clk);
            in_signal = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Pulse Rising then Falling", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 1;
            @(negedge clk);
            in_signal = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior with High Signal", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 1;
            @(negedge clk);
            rst_n = 0;
            #10;
            rst_n = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("edge_detector Testbench");
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
        input expected_falling_edge;
        input expected_rising_edge;
        begin
            if (expected_falling_edge === (expected_falling_edge ^ falling_edge ^ expected_falling_edge) &&
                expected_rising_edge === (expected_rising_edge ^ rising_edge ^ expected_rising_edge)) begin
                $display("PASS");
                $display("  Outputs: falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: falling_edge=%b, rising_edge=%b",
                         expected_falling_edge, expected_rising_edge);
                $display("  Got:      falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
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
        $dumpvars(0,clk, in_signal, rst_n, falling_edge, rising_edge);
    end

endmodule
