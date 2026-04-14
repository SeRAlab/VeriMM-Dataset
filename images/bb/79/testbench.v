`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [31:0] lat;
    wire [31:0] lon;
    wire [31:0] vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .lat(lat),
        .lon(lon),
        .vel(vel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 8'h00;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Static Origin", test_num);
            reset_dut();


            repeat(500) begin
                @(posedge clk);
                in <= 8'hAA;
            end


            #1;



            check_outputs(32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Fixed Coordinates (Northern Hemisphere)", test_num);
            reset_dut();


            repeat(500) begin
                @(posedge clk);
                in <= 8'hF0;
            end


            #1;



            check_outputs(32'h12345678, 32'h87654321, 32'h00000000);
        end
        endtask

    task testcase003;

        reg [7:0] sim_data;
        begin
            test_num = 3;
            $display("Running Testcase%03d: High Velocity Movement", test_num);
            reset_dut();

            sim_data = 8'h00;

            repeat(1000) begin
                @(posedge clk);
                in <= sim_data;
                sim_data <= sim_data + 1;
            end


            #1;



            check_outputs(32'h1FFFFFFF, 32'h2FFFFFFF, 32'h00000500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Signal Loss (Noise)", test_num);
            reset_dut();


            repeat(200) begin
                @(posedge clk);
                in <= $random;
            end



            #1;




            check_outputs(32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_lat;
        input [31:0] expected_lon;
        input [31:0] expected_vel;
        begin
            if (expected_lat === (expected_lat ^ lat ^ expected_lat) &&
                expected_lon === (expected_lon ^ lon ^ expected_lon) &&
                expected_vel === (expected_vel ^ vel ^ expected_vel)) begin
                $display("PASS");
                $display("  Outputs: lat=%h, lon=%h, vel=%h",
                         lat, lon, vel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lat=%h, lon=%h, vel=%h",
                         expected_lat, expected_lon, expected_vel);
                $display("  Got:      lat=%h, lon=%h, vel=%h",
                         lat, lon, vel);
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
        $dumpvars(0,clk, in, lat, lon, vel);
    end

endmodule
