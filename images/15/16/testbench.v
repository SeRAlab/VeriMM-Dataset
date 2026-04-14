`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control_input;
    reg [15:0] measurement;
    reg rst;
    wire [15:0] estimated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control_input(control_input),
        .measurement(measurement),
        .rst(rst),
        .estimated_state(estimated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control_input = 16'h0000;
            measurement = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            measurement = 16'h1000;
            control_input = 16'h0000;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(16'h1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            measurement = 16'h0000;
            control_input = 16'h0200;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h0A00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            control_input = 16'h0050;
            measurement = 16'h0100;
            @(posedge clk);
            measurement = 16'h0150;
            @(posedge clk);
            measurement = 16'h0200;
            @(posedge clk);
            measurement = 16'h0250;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0500);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            control_input = 16'h0000;
            measurement = 16'h0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            measurement = 16'hFFFF;
            control_input = 16'h0000;
            repeat(30) @(posedge clk);
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
        input [15:0] expected_estimated_state;
        begin
            if (expected_estimated_state === (expected_estimated_state ^ estimated_state ^ expected_estimated_state)) begin
                $display("PASS");
                $display("  Outputs: estimated_state=%h",
                         estimated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_state=%h",
                         expected_estimated_state);
                $display("  Got:      estimated_state=%h",
                         estimated_state);
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
        $dumpvars(0,clk, control_input, measurement, rst, estimated_state);
    end

endmodule
