`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] position;
    wire [15:0] velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .position(position),
        .velocity(velocity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 16'h0000;
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
            $display("\nTestcase %0d: Static Position", test_num);
            reset_dut();


            repeat (20) begin
                measurement = 16'h1000;
                @(posedge clk);
                #1;
            end



            #1;




            check_outputs(16'h1000, 16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();


            for (i = 0; i < 30; i = i + 1) begin
                measurement = 16'h0100 + (i * 16'h0010);
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(16'h02D0, 16'h0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Noise Spike Suppression", test_num);
            reset_dut();


            repeat (10) begin
                measurement = 16'h2000;
                @(posedge clk);
                #1;
            end


            measurement = 16'hFFFF;
            @(posedge clk);
            #1;


            measurement = 16'h2000;
            @(posedge clk);
            #1;




            if (position < 16'h4000) begin
                $display("Noise effectively filtered.");
                #1;

                check_outputs(position, velocity);
            end else begin
                $display("Noise spike caused too much deviation.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reverse Movement", test_num);
            reset_dut();


            for (i = 0; i < 20; i = i + 1) begin
                measurement = 16'h5000 - (i * 16'h000A);
                @(posedge clk);
                #1;
            end



            #1;




            check_outputs(16'h4F42, 16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Zeroing", test_num);
            reset_dut();

            measurement = 16'hAAAA;
            repeat (30) @(posedge clk);
            #1;

            measurement = 16'h0000;
            repeat (30) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_position;
        input [15:0] expected_velocity;
        begin
            if (expected_position === (expected_position ^ position ^ expected_position) &&
                expected_velocity === (expected_velocity ^ velocity ^ expected_velocity)) begin
                $display("PASS");
                $display("  Outputs: position=%h, velocity=%h",
                         position, velocity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position=%h, velocity=%h",
                         expected_position, expected_velocity);
                $display("  Got:      position=%h, velocity=%h",
                         position, velocity);
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
        $dumpvars(0,clk, measurement, reset, position, velocity);
    end

endmodule
