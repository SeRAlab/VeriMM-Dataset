`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg signal_in;
    wire zero_crossing_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .signal_in(signal_in),
        .zero_crossing_out(zero_crossing_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal_in = 0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rising Edge Detection (0 -> 1)", test_num);
            reset_dut();


            @(posedge clk);
            #1 signal_in = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Falling Edge Detection (1 -> 0)", test_num);
            reset_dut();


            @(posedge clk);
            #1 signal_in = 1;
            @(posedge clk);


            #1 signal_in = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Constant Low Signal (0 -> 0)", test_num);
            reset_dut();

            signal_in = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Constant High Signal (1 -> 1)", test_num);
            reset_dut();


            @(posedge clk);
            #1 signal_in = 1;
            @(posedge clk);


            #1 signal_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Duration Check (Return to Low)", test_num);
            reset_dut();


            @(posedge clk);
            #1 signal_in = 1;
            @(posedge clk);


            @(posedge clk);
            #1;
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
        input expected_zero_crossing_out;
        begin
            if (expected_zero_crossing_out === (expected_zero_crossing_out ^ zero_crossing_out ^ expected_zero_crossing_out)) begin
                $display("PASS");
                $display("  Outputs: zero_crossing_out=%b",
                         zero_crossing_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero_crossing_out=%b",
                         expected_zero_crossing_out);
                $display("  Got:      zero_crossing_out=%b",
                         zero_crossing_out);
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
        $dumpvars(0,clk, signal_in, zero_crossing_out);
    end

endmodule
