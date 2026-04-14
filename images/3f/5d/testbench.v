`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement1;
    reg [15:0] measurement2;
    reg reset;
    wire [15:0] estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement1(measurement1),
        .measurement2(measurement2),
        .reset(reset),
        .estimated_position(estimated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement1 = 0;
            measurement2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Step Response", test_num);
            reset_dut();
            measurement1 = 16'd400;
            measurement2 = 16'd800;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd300);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Convergence to Steady State", test_num);
            reset_dut();
            measurement1 = 16'd1000;
            measurement2 = 16'd1000;
            repeat(10) @(posedge clk);
            #1;

            if (estimated_position > 16'd990 && estimated_position <= 16'd1000)
                #1;

                check_outputs(estimated_position);
            else
                #1;

                check_outputs(16'd1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sensor Disagreement / Step Response", test_num);
            reset_dut();

            measurement1 = 16'd1000;
            measurement2 = 16'd1000;
            repeat(10) @(posedge clk);


            measurement1 = 16'd2000;
            measurement2 = 16'd1000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd1250);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Zero Input Stability", test_num);
            reset_dut();
            measurement1 = 16'h0000;
            measurement2 = 16'h0000;
            repeat(5) @(posedge clk);
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
        input [15:0] expected_estimated_position;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h",
                         estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h",
                         expected_estimated_position);
                $display("  Got:      estimated_position=%h",
                         estimated_position);
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
        $dumpvars(0,clk, measurement1, measurement2, reset, estimated_position);
    end

endmodule
