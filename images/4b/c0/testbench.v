`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] sensor;
    wire [1:0] dira;
    wire [1:0] dirb;
    wire [2:0] sw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .sensor(sensor),
        .dira(dira),
        .dirb(dirb),
        .sw(sw)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sensor = 5'b00000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 2'b00, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Sensor 0 Triggered", test_num);
            reset_dut();
            sensor = 5'b00001;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b01, 2'b00, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Sensor 2 Triggered", test_num);
            reset_dut();
            sensor = 5'b00100;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b01, 3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Sequential Movement (S0 -> S1)", test_num);
            reset_dut();
            sensor = 5'b00001;
            @(posedge clk);
            sensor = 5'b00010;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b01, 2'b00, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Multi-Sensor Conflict (S0 & S2)", test_num);
            reset_dut();
            sensor = 5'b00101;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(2'b01, 2'b01, 3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: End of Track (S4)", test_num);
            reset_dut();
            sensor = 5'b10000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b00, 3'b111);
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
        input [1:0] expected_dira;
        input [1:0] expected_dirb;
        input [2:0] expected_sw;
        begin
            if (expected_dira === (expected_dira ^ dira ^ expected_dira) &&
                expected_dirb === (expected_dirb ^ dirb ^ expected_dirb) &&
                expected_sw === (expected_sw ^ sw ^ expected_sw)) begin
                $display("PASS");
                $display("  Outputs: dira=%h, dirb=%h, sw=%h",
                         dira, dirb, sw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dira=%h, dirb=%h, sw=%h",
                         expected_dira, expected_dirb, expected_sw);
                $display("  Got:      dira=%h, dirb=%h, sw=%h",
                         dira, dirb, sw);
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
        $dumpvars(0,clk, rst, sensor, dira, dirb, sw);
    end

endmodule
