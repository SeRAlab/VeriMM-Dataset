`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] position_meas;
    reg rst;
    reg [15:0] velocity_meas;
    wire [15:0] filtered_position;
    wire [15:0] filtered_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .position_meas(position_meas),
        .rst(rst),
        .velocity_meas(velocity_meas),
        .filtered_position(filtered_position),
        .filtered_velocity(filtered_velocity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            position_meas = 16'h0000;
            velocity_meas = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initialization and Zero Input", test_num);
            reset_dut();

            position_meas = 16'h0000;
            velocity_meas = 16'h0000;

            repeat (10) @(posedge clk);


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Steady State Convergence", test_num);
            reset_dut();


            position_meas = 16'h03E8;
            velocity_meas = 16'h000A;


            repeat (50) @(posedge clk);



            #1;




            check_outputs(16'h03E8, 16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Dynamic Response", test_num);
            reset_dut();


            position_meas = 16'h0064;
            velocity_meas = 16'h0005;
            @(posedge clk);



            repeat (10) begin
                @(posedge clk);
                position_meas = position_meas + velocity_meas;
            end


            #1;



            check_outputs(16'h0096, 16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Step Change/Noise Filtering", test_num);
            reset_dut();


            position_meas = 16'h01F4;
            velocity_meas = 16'h0000;
            repeat (20) @(posedge clk);


            position_meas = 16'h0320;
            @(posedge clk);






            #1;







            check_outputs(16'h024E, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Large Value Handling", test_num);
            reset_dut();

            position_meas = 16'hF000;
            velocity_meas = 16'h00FF;

            repeat (15) @(posedge clk);

            #1;


            check_outputs(16'hF000, 16'h00FF);
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
        input [15:0] expected_filtered_position;
        input [15:0] expected_filtered_velocity;
        begin
            if (expected_filtered_position === (expected_filtered_position ^ filtered_position ^ expected_filtered_position) &&
                expected_filtered_velocity === (expected_filtered_velocity ^ filtered_velocity ^ expected_filtered_velocity)) begin
                $display("PASS");
                $display("  Outputs: filtered_position=%h, filtered_velocity=%h",
                         filtered_position, filtered_velocity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_position=%h, filtered_velocity=%h",
                         expected_filtered_position, expected_filtered_velocity);
                $display("  Got:      filtered_position=%h, filtered_velocity=%h",
                         filtered_position, filtered_velocity);
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
        $dumpvars(0,clk, position_meas, rst, velocity_meas, filtered_position, filtered_velocity);
    end

endmodule
