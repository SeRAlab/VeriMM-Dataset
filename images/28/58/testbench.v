`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] z_position;
    reg [31:0] z_velocity;
    wire [31:0] x_position;
    wire [31:0] x_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .reset(reset),
        .z_position(z_position),
        .z_velocity(z_velocity),
        .x_position(x_position),
        .x_velocity(x_velocity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        z_position = 32'h0;
        z_velocity = 32'h0;
        repeat(2) @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Static Position Convergence", test_num);
        reset_dut();


        z_position = 32'h000003E8;
        z_velocity = 32'h00000000;

        repeat(20) @(posedge clk);



        #1;




        check_outputs(32'h000003E8, 32'h00000000);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Constant Velocity Tracking", test_num);
        reset_dut();


        z_velocity = 32'h0000000A;
        for (i = 0; i < 50; i = i + 1) begin
            z_position = i * 10;
            @(posedge clk);
        end


        #1;



        check_outputs(32'h000001EA, 32'h0000000A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Impulse Rejection", test_num);
        reset_dut();


        z_position = 32'h0;
        repeat(5) @(posedge clk);


        z_position = 32'h00001388;
        @(posedge clk);


        z_position = 32'h0;
        repeat(5) @(posedge clk);



        if (x_position < 32'h00000100) begin
             #1;

             check_outputs(x_position, x_velocity);
        end else begin
             $display("FAIL: Filter did not sufficiently dampen the impulse spike.");
             fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %04d: Negative Measurement Handling", test_num);
        reset_dut();


        z_position = 32'hFFFFFF9C;
        z_velocity = 32'hFFFFFFF6;

        repeat(30) @(posedge clk);


        #1;



        check_outputs(32'hFFFFFF9C, 32'hFFFFFFF6);
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
        input [31:0] expected_x_position;
        input [31:0] expected_x_velocity;
        begin
            if (expected_x_position === (expected_x_position ^ x_position ^ expected_x_position) &&
                expected_x_velocity === (expected_x_velocity ^ x_velocity ^ expected_x_velocity)) begin
                $display("PASS");
                $display("  Outputs: x_position=%h, x_velocity=%h",
                         x_position, x_velocity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_position=%h, x_velocity=%h",
                         expected_x_position, expected_x_velocity);
                $display("  Got:      x_position=%h, x_velocity=%h",
                         x_position, x_velocity);
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
        $dumpvars(0,clk, reset, z_position, z_velocity, x_position, x_velocity);
    end

endmodule
