`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] estimated_state;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] new_estimated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .estimated_state(estimated_state),
        .measurement(measurement),
        .reset(reset),
        .new_estimated_state(new_estimated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            estimated_state = 16'h0;
            measurement = 16'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Innovation", test_num);
            reset_dut();
            estimated_state = 16'h1000;
            measurement     = 16'h1000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Innovation (K=0.5)", test_num);
            reset_dut();
            estimated_state = 16'h2000;
            measurement     = 16'h4000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h3000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Innovation (K=0.5)", test_num);
            reset_dut();
            estimated_state = 16'h8000;
            measurement     = 16'h4000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h6000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Zeros", test_num);
            reset_dut();
            estimated_state = 16'h0000;
            measurement     = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Max Values", test_num);
            reset_dut();
            estimated_state = 16'hFFFF;
            measurement     = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset behavior during operation", test_num);
            reset_dut();
            estimated_state = 16'hABCD;
            measurement     = 16'h1234;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_new_estimated_state;
        begin
            if (expected_new_estimated_state === (expected_new_estimated_state ^ new_estimated_state ^ expected_new_estimated_state)) begin
                $display("PASS");
                $display("  Outputs: new_estimated_state=%h",
                         new_estimated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_estimated_state=%h",
                         expected_new_estimated_state);
                $display("  Got:      new_estimated_state=%h",
                         new_estimated_state);
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
        $dumpvars(0,clk, estimated_state, measurement, reset, new_estimated_state);
    end

endmodule
