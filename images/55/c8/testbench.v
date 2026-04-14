`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gps_rx;
    reg rst;
    wire [15:0] altitude;
    wire [31:0] latitude;
    wire [31:0] longitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gps_rx(gps_rx),
        .rst(rst),
        .altitude(altitude),
        .latitude(latitude),
        .longitude(longitude)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        gps_rx = 1;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Full 24-bit Packet Reception", test_num);
        reset_dut();


        send_gps_packet(24'hABCDEF);



        #1;




        check_outputs(16'hCDEF, 32'h00ABCDEF, 32'h00ABCDEF);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset during transmission", test_num);
        reset_dut();


        gps_rx = 0;
        @(posedge clk);
        for (i = 0; i < 12; i = i + 1) begin
            gps_rx = i[0];
            @(posedge clk);
        end


        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;


        #1;



        check_outputs(16'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Multiple consecutive transmissions", test_num);
        reset_dut();


        send_gps_packet(24'h111111);


        send_gps_packet(24'h222222);


        #1;



        check_outputs(16'h2222, 32'h00222222, 32'h00222222);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Zero data packet", test_num);
        reset_dut();

        send_gps_packet(24'h000000);

        #1;


        check_outputs(16'h0, 32'h0, 32'h0);
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
        input [15:0] expected_altitude;
        input [31:0] expected_latitude;
        input [31:0] expected_longitude;
        begin
            if (expected_altitude === (expected_altitude ^ altitude ^ expected_altitude) &&
                expected_latitude === (expected_latitude ^ latitude ^ expected_latitude) &&
                expected_longitude === (expected_longitude ^ longitude ^ expected_longitude)) begin
                $display("PASS");
                $display("  Outputs: altitude=%h, latitude=%h, longitude=%h",
                         altitude, latitude, longitude);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: altitude=%h, latitude=%h, longitude=%h",
                         expected_altitude, expected_latitude, expected_longitude);
                $display("  Got:      altitude=%h, latitude=%h, longitude=%h",
                         altitude, latitude, longitude);
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
        $dumpvars(0,clk, gps_rx, rst, altitude, latitude, longitude);
    end

endmodule
