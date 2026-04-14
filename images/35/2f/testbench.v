`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measured_position;
    reg [15:0] measured_velocity;
    reg reset;
    wire [15:0] estimated_position;
    wire [15:0] estimated_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measured_position(measured_position),
        .measured_velocity(measured_velocity),
        .reset(reset),
        .estimated_position(estimated_position),
        .estimated_velocity(estimated_velocity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measured_position = 16'h0000;
            measured_velocity = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Steady State Convergence", test_num);
            reset_dut();


            measured_position = 16'h03E8;
            measured_velocity = 16'h0032;


            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end
            #1;


            #1;



            check_outputs(16'h03E8, 16'h0032);
        end
        endtask

    task testcase003;

        integer i;
        reg [15:0] pos_tracker;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();

            pos_tracker = 16'h0000;
            measured_velocity = 16'h0010;

            for (i = 0; i < 15; i = i + 1) begin
                pos_tracker = pos_tracker + measured_velocity;
                measured_position = pos_tracker;
                @(posedge clk);
            end
            #1;


            #1;



            check_outputs(16'h00F0, 16'h0010);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Noise Suppression", test_num);
            reset_dut();



            for (i = 0; i < 30; i = i + 1) begin
                if (i % 2 == 0)
                    measured_position = 16'h01FE;
                else
                    measured_position = 16'h01EA;

                measured_velocity = 16'h0000;
                @(posedge clk);
            end
            #1;




            #1;





            check_outputs(16'h01F4, 16'h0000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Velocity Step Change", test_num);
            reset_dut();

            measured_position = 16'h0064;
            measured_velocity = 16'h0000;


            repeat(10) @(posedge clk);


            measured_velocity = 16'h00FF;


            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(estimated_position, 16'h00FF);
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
        input [15:0] expected_estimated_velocity;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position) &&
                expected_estimated_velocity === (expected_estimated_velocity ^ estimated_velocity ^ expected_estimated_velocity)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h, estimated_velocity=%h",
                         estimated_position, estimated_velocity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h, estimated_velocity=%h",
                         expected_estimated_position, expected_estimated_velocity);
                $display("  Got:      estimated_position=%h, estimated_velocity=%h",
                         estimated_position, estimated_velocity);
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
        $dumpvars(0,clk, measured_position, measured_velocity, reset, estimated_position, estimated_velocity);
    end

endmodule
