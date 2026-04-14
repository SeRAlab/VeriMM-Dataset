`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] sensor_a;
    reg [7:0] sensor_b;
    wire [7:0] estimated_state;
    wire [7:0] estimated_uncertainty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .rst(rst),
        .sensor_a(sensor_a),
        .sensor_b(sensor_b),
        .estimated_state(estimated_state),
        .estimated_uncertainty(estimated_uncertainty)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sensor_a = 0;
            sensor_b = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Convergence to Stable Input", test_num);
            reset_dut();


            sensor_a = 8'd100;
            sensor_b = 8'd100;


            repeat (10) @(posedge clk);



            #1;




            check_outputs(8'h64, estimated_uncertainty);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sensor Fusion (Discrepancy)", test_num);
            reset_dut();

            sensor_a = 8'd40;
            sensor_b = 8'd60;

            repeat (10) @(posedge clk);



            #1;




            check_outputs(8'h32, estimated_uncertainty);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Scale Input", test_num);
            reset_dut();

            sensor_a = 8'hFF;
            sensor_b = 8'hFF;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'hFF, estimated_uncertainty);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Tracking", test_num);
            reset_dut();


            sensor_a = 8'd20;
            sensor_b = 8'd20;
            repeat (5) @(posedge clk);


            sensor_a = 8'd200;
            sensor_b = 8'd200;
            repeat (15) @(posedge clk);

            #1;


            check_outputs(8'd200, estimated_uncertainty);
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
        input [7:0] expected_estimated_state;
        input [7:0] expected_estimated_uncertainty;
        begin
            if (expected_estimated_state === (expected_estimated_state ^ estimated_state ^ expected_estimated_state) &&
                expected_estimated_uncertainty === (expected_estimated_uncertainty ^ estimated_uncertainty ^ expected_estimated_uncertainty)) begin
                $display("PASS");
                $display("  Outputs: estimated_state=%h, estimated_uncertainty=%h",
                         estimated_state, estimated_uncertainty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_state=%h, estimated_uncertainty=%h",
                         expected_estimated_state, expected_estimated_uncertainty);
                $display("  Got:      estimated_state=%h, estimated_uncertainty=%h",
                         estimated_state, estimated_uncertainty);
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
        $dumpvars(0,clk, rst, sensor_a, sensor_b, estimated_state, estimated_uncertainty);
    end

endmodule
