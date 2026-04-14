`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] performance_req;
    wire [3:0] frequency;
    wire [3:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .performance_req(performance_req),
        .frequency(frequency),
        .voltage(voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        performance_req = 2'b00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Low Performance Request (00)", test_num);
        reset_dut();

        performance_req = 2'b00;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd1, 4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Medium Performance Request (01)", test_num);
        reset_dut();

        performance_req = 2'b01;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd2, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: High Performance Request (10)", test_num);
        reset_dut();

        performance_req = 2'b10;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd3, 4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Maximum Performance Request (11)", test_num);
        reset_dut();

        performance_req = 2'b11;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd4, 4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Transition from Max to Low", test_num);
        reset_dut();


        performance_req = 2'b11;
        @(posedge clk);
        #1;


        performance_req = 2'b00;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'd1, 4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Stability Check (Multiple Cycles)", test_num);
        reset_dut();

        performance_req = 2'b10;
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(4'd3, 4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [3:0] expected_frequency;
        input [3:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
        $dumpvars(0,clk, performance_req, frequency, voltage);
    end

endmodule
