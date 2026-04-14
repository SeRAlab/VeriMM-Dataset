`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal;
    wire crossing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .crossing(crossing)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            signal = 0;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Crossing (0 -> 1)", test_num);
            reset_dut();

            @(negedge clk);
            signal = 0;
            @(negedge clk);
            signal = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Crossing (1 -> 0)", test_num);
            reset_dut();


            @(negedge clk);
            signal = 1;
            @(posedge clk);

            @(negedge clk);
            signal = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Steady Low (0 -> 0)", test_num);
            reset_dut();

            @(negedge clk);
            signal = 0;
            repeat (2) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Steady High (1 -> 1)", test_num);
            reset_dut();


            @(negedge clk);
            signal = 1;
            @(posedge clk);


            @(negedge clk);
            signal = 1;
            @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequence 0 -> 1 -> 0", test_num);
            reset_dut();

            @(negedge clk) signal = 0;
            @(negedge clk) signal = 1;
            @(negedge clk) signal = 0;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during crossing", test_num);
            reset_dut();

            @(negedge clk) signal = 1;
            @(posedge clk);


            reset = 1;
            #2;
            #1;

            check_outputs(1'b0);
            reset = 0;
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
        $dumpvars(0,clk, reset, signal, crossing);
    end

endmodule
