`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sensor1_pos;
    reg [15:0] sensor2_pos;
    wire [15:0] estimated_pos;
    wire [15:0] estimated_vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .reset(reset),
        .sensor1_pos(sensor1_pos),
        .sensor2_pos(sensor2_pos),
        .estimated_pos(estimated_pos),
        .estimated_vel(estimated_vel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sensor1_pos = 16'd0;
            sensor2_pos = 16'd0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %0d: Static Convergence", test_num);
            reset_dut();

            sensor1_pos = 16'd1000;
            sensor2_pos = 16'd1000;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'd1000, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %0d: Sensor Fusion (Average)", test_num);
            reset_dut();

            sensor1_pos = 16'd2000;
            sensor2_pos = 16'd4000;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'd3000, 16'd0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nRunning Testcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();


            for (i = 0; i < 20; i = i + 1) begin
                sensor1_pos = i * 10;
                sensor2_pos = i * 10;
                @(posedge clk);
            end


            #1;



            check_outputs(16'd190, 16'd10);
        end
        endtask

    task testcase005;

        integer j;
        begin
            test_num = 5;
            $display("\nRunning Testcase %0d: High Value Transition", test_num);
            reset_dut();


            sensor1_pos = 16'hF000;
            sensor2_pos = 16'hF000;
            repeat(5) @(posedge clk);


            for (j = 0; j < 10; j = j + 1) begin
                sensor1_pos = 16'hF000 - (j * 20);
                sensor2_pos = 16'hF000 - (j * 20);
                @(posedge clk);
            end



            #1;




            check_outputs(16'hEF4C, 16'hFFEC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        input [15:0] expected_estimated_pos;
        input [15:0] expected_estimated_vel;
        begin
            if (expected_estimated_pos === (expected_estimated_pos ^ estimated_pos ^ expected_estimated_pos) &&
                expected_estimated_vel === (expected_estimated_vel ^ estimated_vel ^ expected_estimated_vel)) begin
                $display("PASS");
                $display("  Outputs: estimated_pos=%h, estimated_vel=%h",
                         estimated_pos, estimated_vel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_pos=%h, estimated_vel=%h",
                         expected_estimated_pos, expected_estimated_vel);
                $display("  Got:      estimated_pos=%h, estimated_vel=%h",
                         estimated_pos, estimated_vel);
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
        $dumpvars(0,clk, reset, sensor1_pos, sensor2_pos, estimated_pos, estimated_vel);
    end

endmodule
