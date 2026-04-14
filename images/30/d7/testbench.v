`timescale 1ns/1ps

module slam_state_machine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] sensor_data;
    wire [2:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_state_machine dut (
        .clk(clk),
        .rst(rst),
        .sensor_data(sensor_data),
        .position(position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sensor_data = 2'b00;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Step (sensor=00)", test_num);
            reset_dut();
            sensor_data = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Obstacle Detection (sensor=01)", test_num);
            reset_dut();
            sensor_data = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Move 3 steps then encounter obstacle", test_num);
            reset_dut();


            sensor_data = 2'b00;
            repeat(3) @(posedge clk);


            #1 sensor_data = 2'b10;
            @(posedge clk);

            #1 #1;
 check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around Check (7 -> 0)", test_num);
            reset_dut();

            sensor_data = 2'b00;
            repeat(8) @(posedge clk);

            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Path", test_num);
            reset_dut();

            sensor_data = 2'b00; @(posedge clk);
            #1 sensor_data = 2'b11; @(posedge clk);
            #1 sensor_data = 2'b00; @(posedge clk);
            #1 sensor_data = 2'b10; @(posedge clk);

            #1 #1;
 check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_state_machine Testbench");
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
        input [2:0] expected_position;
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
        $dumpvars(0,clk, rst, sensor_data, position);
    end

endmodule
