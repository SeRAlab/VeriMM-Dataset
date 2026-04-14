`timescale 1ns/1ps

module divide_by_4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal_in;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_4 dut (
        .clk(clk),
        .reset(reset),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            signal_in = 0;
            @(negedge clk);
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: 4 consecutive high cycles", test_num);
            reset_dut();

            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 3 consecutive high cycles (expect low output)", test_num);
            reset_dut();
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Interrupted high sequence", test_num);
            reset_dut();
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 0;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 5 consecutive high cycles", test_num);
            reset_dut();
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Signal remains low", test_num);
            reset_dut();
            repeat(5) @(negedge clk) signal_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during high sequence", test_num);
            reset_dut();
            @(negedge clk) signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(negedge clk) reset = 1;
            @(negedge clk) reset = 0; signal_in = 1;
            @(negedge clk) signal_in = 1;
            @(posedge clk);
            #1;
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
        $display("divide_by_4 Testbench");
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
        input expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%b",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%b",
                         expected_signal_out);
                $display("  Got:      signal_out=%b",
                         signal_out);
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
        $dumpvars(0,clk, reset, signal_in, signal_out);
    end

endmodule
