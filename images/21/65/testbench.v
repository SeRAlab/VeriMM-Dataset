`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg signal_in;
    wire crossing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .crossing(crossing)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single crossing (0 -> 1)", test_num);
            reset_dut();
            @(posedge clk);
            signal_in = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Double crossing (0 -> 1 -> 0)", test_num);
            reset_dut();
            @(posedge clk);
            signal_in = 1;
            @(posedge clk);
            signal_in = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Triple crossing (0 -> 1 -> 0 -> 1)", test_num);
            reset_dut();
            @(posedge clk);
            signal_in = 1;
            @(posedge clk);
            signal_in = 0;
            @(posedge clk);
            signal_in = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Rapid crossings (every cycle)", test_num);
            reset_dut();
            repeat(4) begin
                @(posedge clk);
                signal_in = ~signal_in;
            end
            repeat(2) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset with signal high then transition to low", test_num);
            rst = 1;
            signal_in = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            signal_in = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: No crossing (signal remains constant)", test_num);
            reset_dut();
            signal_in = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zero_crossing_detector Testbench");
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
        input expected_crossing;
        begin
            if (expected_crossing === (expected_crossing ^ crossing ^ expected_crossing)) begin
                $display("PASS");
                $display("  Outputs: crossing=%b",
                         crossing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crossing=%b",
                         expected_crossing);
                $display("  Got:      crossing=%b",
                         crossing);
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
        $dumpvars(0,clk, rst, signal_in, crossing);
    end

endmodule
