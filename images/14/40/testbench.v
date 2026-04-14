`timescale 1ns/1ps

module SLAM_Module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg rst;
    reg [3:0] sensor_data;
    wire [3:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_Module dut (
        .clk(clk),
        .direction(direction),
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
            direction = 2'b00;
            sensor_data = 4'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Movement North", test_num);
            reset_dut();

            direction = 2'b00;
            sensor_data = 4'h3;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Path Tracking (East then North)", test_num);
            reset_dut();


            direction = 2'b01;
            sensor_data = 4'h2;
            @(posedge clk);


            direction = 2'b00;
            sensor_data = 4'h4;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Displacement (South/West)", test_num);
            reset_dut();


            direction = 2'b00;
            sensor_data = 4'h8;
            @(posedge clk);


            direction = 2'b10;
            sensor_data = 4'h3;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap-around Check", test_num);
            reset_dut();


            direction = 2'b00;
            sensor_data = 4'hF;
            @(posedge clk);


            direction = 2'b00;
            sensor_data = 4'h2;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Return to Origin Loop", test_num);
            reset_dut();

            direction = 2'b00; sensor_data = 4'h5; @(posedge clk);
            direction = 2'b01; sensor_data = 4'h2; @(posedge clk);
            direction = 2'b10; sensor_data = 4'h5; @(posedge clk);
            direction = 2'b11; sensor_data = 4'h2; @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM_Module Testbench");
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
        input [3:0] expected_position;
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
        $dumpvars(0,clk, direction, rst, sensor_data, position);
    end

endmodule
