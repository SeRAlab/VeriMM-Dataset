`timescale 1ns/1ps

module SLAM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] sensor_data;
    reg update_map;
    wire [15:0] estimated_position;
    wire map_updated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM dut (
        .clk(clk),
        .reset(reset),
        .sensor_data(sensor_data),
        .update_map(update_map),
        .estimated_position(estimated_position),
        .map_updated(map_updated)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            sensor_data = 0;
            update_map = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Position Update", test_num);
            reset_dut();

            sensor_data = 8'h10;
            update_map = 1;
            @(posedge clk);
            update_map = 0;


            repeat (2) @(posedge clk);

            #1;


            check_outputs(16'h0010, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Sequential Updates", test_num);
            reset_dut();


            sensor_data = 8'd5;
            update_map = 1;
            @(posedge clk);
            update_map = 0;
            @(posedge clk);


            sensor_data = 8'd15;
            update_map = 1;
            @(posedge clk);
            update_map = 0;
            @(posedge clk);


            sensor_data = 8'd30;
            update_map = 1;
            @(posedge clk);
            update_map = 0;

            repeat (2) @(posedge clk);


            #1;



            check_outputs(16'h0032, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: No Update when update_map is low", test_num);
            reset_dut();

            sensor_data = 8'hFF;
            update_map = 0;
            repeat (5) @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Maximum Sensor Data Input", test_num);
            reset_dut();

            sensor_data = 8'hFF;
            update_map = 1;
            @(posedge clk);
            update_map = 0;
            repeat (2) @(posedge clk);

            sensor_data = 8'hFF;
            update_map = 1;
            @(posedge clk);
            update_map = 0;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(16'h01FE, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM Testbench");
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
        input expected_map_updated;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position) &&
                expected_map_updated === (expected_map_updated ^ map_updated ^ expected_map_updated)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h, map_updated=%b",
                         estimated_position, map_updated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h, map_updated=%b",
                         expected_estimated_position, expected_map_updated);
                $display("  Got:      estimated_position=%h, map_updated=%b",
                         estimated_position, map_updated);
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
        $dumpvars(0,clk, reset, sensor_data, update_map, estimated_position, map_updated);
    end

endmodule
