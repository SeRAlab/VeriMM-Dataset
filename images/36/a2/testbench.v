`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_input;
    reg reset;
    wire current_exceeds_threshold;
    wire [7:0] current_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .clk(clk),
        .current_input(current_input),
        .reset(reset),
        .current_exceeds_threshold(current_exceeds_threshold),
        .current_value(current_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_input = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Behavior Check", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Below Threshold (50)", test_num);
            reset_dut();
            current_input = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Above Threshold (150)", test_num);
            reset_dut();
            current_input = 8'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Check (100)", test_num);
            reset_dut();
            current_input = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Value Check", test_num);
            reset_dut();

            current_input = 8'd75;
            @(posedge clk);
            #1;

            current_input = 8'd200;
            #5;

            #1;


            check_outputs(1'b0, 8'd75);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Input Value (255)", test_num);
            reset_dut();
            current_input = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor Testbench");
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
        input expected_current_exceeds_threshold;
        input [7:0] expected_current_value;
        begin
            if (expected_current_exceeds_threshold === (expected_current_exceeds_threshold ^ current_exceeds_threshold ^ expected_current_exceeds_threshold) &&
                expected_current_value === (expected_current_value ^ current_value ^ expected_current_value)) begin
                $display("PASS");
                $display("  Outputs: current_exceeds_threshold=%b, current_value=%h",
                         current_exceeds_threshold, current_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_exceeds_threshold=%b, current_value=%h",
                         expected_current_exceeds_threshold, expected_current_value);
                $display("  Got:      current_exceeds_threshold=%b, current_value=%h",
                         current_exceeds_threshold, current_value);
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
        $dumpvars(0,clk, current_input, reset, current_exceeds_threshold, current_value);
    end

endmodule
