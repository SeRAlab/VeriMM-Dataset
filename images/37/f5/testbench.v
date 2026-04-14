`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] covariance1;
    reg [15:0] covariance2;
    reg reset;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] estimated_covariance;
    wire [15:0] estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .covariance1(covariance1),
        .covariance2(covariance2),
        .reset(reset),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .estimated_covariance(estimated_covariance),
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
            sensor1 = 0;
            sensor2 = 0;
            covariance1 = 0;
            covariance2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal uncertainty (50/50 fusion)", test_num);
            reset_dut();
            sensor1 = 16'd100;
            sensor2 = 16'd200;
            covariance1 = 16'd50;
            covariance2 = 16'd50;

            repeat(2) @(posedge clk);


            #1 #1;
 check_outputs(16'd25, 16'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sensor 1 dominant", test_num);
            reset_dut();
            sensor1 = 16'd100;
            sensor2 = 16'd200;
            covariance1 = 16'd10;
            covariance2 = 16'd40;
            repeat(2) @(posedge clk);


            #1 #1;
 check_outputs(16'd8, 16'd120);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sensor 2 dominant", test_num);
            reset_dut();
            sensor1 = 16'd200;
            sensor2 = 16'd100;
            covariance1 = 16'd40;
            covariance2 = 16'd10;
            repeat(2) @(posedge clk);


            #1 #1;
 check_outputs(16'd8, 16'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large values", test_num);
            reset_dut();
            sensor1 = 16'd1000;
            sensor2 = 16'd2000;
            covariance1 = 16'd500;
            covariance2 = 16'd500;
            repeat(2) @(posedge clk);


            #1 #1;
 check_outputs(16'd250, 16'd1500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero measurements", test_num);
            reset_dut();
            sensor1 = 16'd0;
            sensor2 = 16'd0;
            covariance1 = 16'd20;
            covariance2 = 16'd20;
            repeat(2) @(posedge clk);


            #1 #1;
 check_outputs(16'd10, 16'd0);
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
        input [15:0] expected_estimated_covariance;
        input [15:0] expected_estimated_position;
        begin
            if (expected_estimated_covariance === (expected_estimated_covariance ^ estimated_covariance ^ expected_estimated_covariance) &&
                expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: estimated_covariance=%h, estimated_position=%h",
                         estimated_covariance, estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_covariance=%h, estimated_position=%h",
                         expected_estimated_covariance, expected_estimated_position);
                $display("  Got:      estimated_covariance=%h, estimated_position=%h",
                         estimated_covariance, estimated_position);
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
        $dumpvars(0,clk, covariance1, covariance2, reset, sensor1, sensor2, estimated_covariance, estimated_position);
    end

endmodule
