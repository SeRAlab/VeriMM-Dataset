`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] desired_signal;
    reg [15:0] input_signal;
    reg rst;
    reg [15:0] step_size;
    wire [15:0] coefficient_0;
    wire [15:0] coefficient_1;
    wire [15:0] filtered_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .desired_signal(desired_signal),
        .input_signal(input_signal),
        .rst(rst),
        .step_size(step_size),
        .coefficient_0(coefficient_0),
        .coefficient_1(coefficient_1),
        .filtered_signal(filtered_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_signal = 16'h0000;
            desired_signal = 16'h0000;
            step_size = 16'h0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Step Size (No Adaptation)", test_num);
            reset_dut();
            input_signal = 16'h00FF;
            desired_signal = 16'h00FF;
            step_size = 16'h0000;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Coefficient 0 Update", test_num);
            reset_dut();



            input_signal = 16'h0002;
            desired_signal = 16'h000A;
            step_size = 16'h0001;
            @(posedge clk);


            #1;

            #1;


            check_outputs(16'h0014, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Coefficient 1 Update (Delay Line)", test_num);
            reset_dut();

            step_size = 16'h0001;

            input_signal = 16'h0002;
            desired_signal = 16'h000A;
            @(posedge clk);






            input_signal = 16'h0004;
            desired_signal = 16'h000A;
            @(posedge clk);

            #1;


            #1;



            check_outputs(16'hFF72, 16'hFF74, 16'h0050);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Error Minimization/Stability", test_num);
            reset_dut();

            input_signal = 16'h0001;
            desired_signal = 16'h0001;
            step_size = 16'h0001;


            repeat(1) @(posedge clk);


            input_signal = 16'h0001;
            desired_signal = 16'h0001;
            @(posedge clk);


            #1;

            #1;


            check_outputs(16'h0001, 16'h0001, 16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms_filter Testbench");
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
        input [15:0] expected_coefficient_0;
        input [15:0] expected_coefficient_1;
        input [15:0] expected_filtered_signal;
        begin
            if (expected_coefficient_0 === (expected_coefficient_0 ^ coefficient_0 ^ expected_coefficient_0) &&
                expected_coefficient_1 === (expected_coefficient_1 ^ coefficient_1 ^ expected_coefficient_1) &&
                expected_filtered_signal === (expected_filtered_signal ^ filtered_signal ^ expected_filtered_signal)) begin
                $display("PASS");
                $display("  Outputs: coefficient_0=%h, coefficient_1=%h, filtered_signal=%h",
                         coefficient_0, coefficient_1, filtered_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: coefficient_0=%h, coefficient_1=%h, filtered_signal=%h",
                         expected_coefficient_0, expected_coefficient_1, expected_filtered_signal);
                $display("  Got:      coefficient_0=%h, coefficient_1=%h, filtered_signal=%h",
                         coefficient_0, coefficient_1, filtered_signal);
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
        $dumpvars(0,clk, desired_signal, input_signal, rst, step_size, coefficient_0, coefficient_1, filtered_signal);
    end

endmodule
