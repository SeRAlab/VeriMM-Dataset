`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg signal;
    wire zero_cross;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .signal(signal),
        .zero_cross(zero_cross)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal = 0;

            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: 0 to 1 transition", test_num);

            signal = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: 1 to 0 transition", test_num);


            signal = 1;
            @(posedge clk);
            #1;


            signal = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Steady 0 (no crossing)", test_num);

            signal = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Steady 1 (no crossing)", test_num);


            signal = 1;
            @(posedge clk);
            #1;


            signal = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Back-to-back transitions", test_num);


            signal = 1;
            @(posedge clk);
            #1;


            signal = 0;
            @(posedge clk);
            #2;


            #1;



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
        input expected_zero_cross;
        begin
            if (expected_zero_cross === (expected_zero_cross ^ zero_cross ^ expected_zero_cross)) begin
                $display("PASS");
                $display("  Outputs: zero_cross=%b",
                         zero_cross);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero_cross=%b",
                         expected_zero_cross);
                $display("  Got:      zero_cross=%b",
                         zero_cross);
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
        $dumpvars(0,clk, signal, zero_cross);
    end

endmodule
