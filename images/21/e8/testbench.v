`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .rst(rst),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .estimated_position(estimated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        sensor1 = 16'h0;
        sensor2 = 16'h0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Identical Sensor Inputs", test_num);
        reset_dut();

        sensor1 = 16'h1000;
        sensor2 = 16'h1000;


        repeat(10) @(posedge clk);


        #1;



        check_outputs(16'h1000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Divergent Sensor Inputs", test_num);
        reset_dut();

        sensor1 = 16'h2000;
        sensor2 = 16'h4000;

        repeat(15) @(posedge clk);



        #1;




        check_outputs(16'h3000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Step Response", test_num);
        reset_dut();


        sensor1 = 16'h0500;
        sensor2 = 16'h0500;
        repeat(5) @(posedge clk);


        sensor1 = 16'h7000;
        sensor2 = 16'h7000;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(16'h7000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Full Scale Inputs", test_num);
        reset_dut();

        sensor1 = 16'hFFFF;
        sensor2 = 16'hFFFF;

        repeat(10) @(posedge clk);


        #1;



        check_outputs(16'hFFFF);
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
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h",
                         estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h",
                         expected_estimated_position);
                $display("  Got:      estimated_position=%h",
                         estimated_position);
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
        $dumpvars(0,clk, rst, sensor1, sensor2, estimated_position);
    end

endmodule
