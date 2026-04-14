`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal_in;
    wire zero_crossed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .reset(reset),
        .signal_in(signal_in),
        .zero_crossed(zero_crossed)
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Detection of Low to High transition", test_num);
            reset_dut();

            signal_in = 0;
            @(posedge clk);
            signal_in = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Detection of High to Low transition", test_num);
            reset_dut();

            signal_in = 1;
            @(posedge clk);
            @(posedge clk);
            signal_in = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No transition (Steady Low)", test_num);
            reset_dut();

            signal_in = 0;
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No transition (Steady High)", test_num);
            reset_dut();

            signal_in = 1;
            @(posedge clk);
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset priority during transition", test_num);
            reset_dut();

            signal_in = 0;
            @(posedge clk);
            reset = 1;
            signal_in = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple consecutive crossings", test_num);
            reset_dut();

            signal_in = 1; @(posedge clk);
            signal_in = 0; @(posedge clk);
            signal_in = 1; @(posedge clk);

            #1 #1;
 check_outputs(1'b1);
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
        input expected_zero_crossed;
        begin
            if (expected_zero_crossed === (expected_zero_crossed ^ zero_crossed ^ expected_zero_crossed)) begin
                $display("PASS");
                $display("  Outputs: zero_crossed=%b",
                         zero_crossed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero_crossed=%b",
                         expected_zero_crossed);
                $display("  Got:      zero_crossed=%b",
                         zero_crossed);
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
        $dumpvars(0,clk, reset, signal_in, zero_crossed);
    end

endmodule
