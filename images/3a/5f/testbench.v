`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal;
    wire [1:0] crossing_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .crossing_state(crossing_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            signal = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Detecting Rising Edge (0 -> 1)", test_num);
            reset_dut();
            signal = 0;
            @(posedge clk);
            signal = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Detecting Falling Edge (1 -> 0)", test_num);
            reset_dut();
            signal = 1;
            @(posedge clk);
            signal = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Steady Low Signal (No Crossing)", test_num);
            reset_dut();
            signal = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Steady High Signal (No Crossing)", test_num);
            reset_dut();
            signal = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signal stays High after Rising Edge (Should return to 0 state)", test_num);
            reset_dut();
            signal = 0;
            @(posedge clk);
            signal = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify output is 0 during reset", test_num);
            reset_dut();
            reset = 1;
            signal = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
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
        input [1:0] expected_crossing_state;
        begin
            if (expected_crossing_state === (expected_crossing_state ^ crossing_state ^ expected_crossing_state)) begin
                $display("PASS");
                $display("  Outputs: crossing_state=%h",
                         crossing_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crossing_state=%h",
                         expected_crossing_state);
                $display("  Got:      crossing_state=%h",
                         crossing_state);
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
        $dumpvars(0,clk, reset, signal, crossing_state);
    end

endmodule
