`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [3:0] distance;
    reg reset;
    wire [3:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .control(control),
        .distance(distance),
        .reset(reset),
        .position(position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        control = 0;
        distance = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Position Update", test_num);
        reset_dut();
        control = 1;
        distance = 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Retain Position (Control=0)", test_num);
        reset_dut();

        control = 1;
        distance = 4'd10;
        @(posedge clk);

        #1 control = 0;
        distance = 4'd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple Consecutive Updates", test_num);
        reset_dut();
        control = 1;
        distance = 4'd2;
        @(posedge clk);
        #1 distance = 4'd7;
        @(posedge clk);
        #1 distance = 4'd15;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Zero Distance Update", test_num);
        reset_dut();
        control = 1;
        distance = 4'd8;
        @(posedge clk);
        #1 distance = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Boundary Value (15)", test_num);
        reset_dut();
        control = 1;
        distance = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset after Update", test_num);
        reset_dut();
        control = 1;
        distance = 4'd12;
        @(posedge clk);
        #1 reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_system Testbench");
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
        input [3:0] expected_position;
        begin
            if (expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: position=%h",
                         position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position=%h",
                         expected_position);
                $display("  Got:      position=%h",
                         position);
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
        $dumpvars(0,clk, control, distance, reset, position);
    end

endmodule
