`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] sensor_reading;
    wire [7:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .reset(reset),
        .sensor_reading(sensor_reading),
        .position(position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sensor_reading = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset to Zero", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Position Update", test_num);
            reset_dut();
            sensor_reading = 8'h0A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Sequential Updates", test_num);
            reset_dut();
            sensor_reading = 8'h05;
            @(posedge clk);
            #1;
            sensor_reading = 8'h02;
            @(posedge clk);
            #1;
            sensor_reading = 8'h03;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Reading (Stay Stationary)", test_num);
            reset_dut();
            sensor_reading = 8'h10;
            @(posedge clk);
            #1;
            sensor_reading = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Accumulator Overflow (Wrap Around)", test_num);
            reset_dut();
            sensor_reading = 8'hFF;
            @(posedge clk);
            #1;
            sensor_reading = 8'h02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Delta Updates", test_num);
            reset_dut();
            sensor_reading = 8'h40;
            @(posedge clk);
            #1;
            sensor_reading = 8'h40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_system Testbench");
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
        input [7:0] expected_position;
        begin
            if (expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: position=%h",
                         position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position=%h",
                         expected_position);
                $display("  Got:      position=%h",
                         position);
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
        $dumpvars(0,clk, reset, sensor_reading, position);
    end

endmodule
