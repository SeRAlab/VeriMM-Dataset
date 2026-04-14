`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] input1;
    reg [15:0] input2;
    reg reset;
    wire [15:0] output_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .control(control),
        .input1(input1),
        .input2(input2),
        .reset(reset),
        .output_estimate(output_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 16'h0000;
            input1 = 16'h0000;
            input2 = 16'h0000;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero Input Tracking", test_num);
            reset_dut();

            input1 = 16'h0000;
            input2 = 16'h0000;
            control = 16'h0000;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Steady State Convergence", test_num);
            reset_dut();


            input1 = 16'h00C8;
            input2 = 16'h00C8;
            control = 16'h0000;


            repeat(20) @(posedge clk);

            #1;


            check_outputs(16'h00C8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Sensor Fusion Averaging", test_num);
            reset_dut();

            input1 = 16'h0064;
            input2 = 16'h012C;
            control = 16'h0000;


            repeat(30) @(posedge clk);


            #1;



            check_outputs(16'h00C8);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Control Input Integration", test_num);
            reset_dut();



            control = 16'd10;
            for (i = 1; i <= 20; i = i + 1) begin
                input1 = i * 10;
                input2 = i * 10;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h00C8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: High Value Handling", test_num);
            reset_dut();

            input1 = 16'hF000;
            input2 = 16'hF000;
            control = 16'h0000;

            repeat(25) @(posedge clk);

            #1;


            check_outputs(16'hF000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        input [15:0] expected_output_estimate;
        begin
            if (expected_output_estimate === (expected_output_estimate ^ output_estimate ^ expected_output_estimate)) begin
                $display("PASS");
                $display("  Outputs: output_estimate=%h",
                         output_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_estimate=%h",
                         expected_output_estimate);
                $display("  Got:      output_estimate=%h",
                         output_estimate);
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
        $dumpvars(0,clk, control, input1, input2, reset, output_estimate);
    end

endmodule
