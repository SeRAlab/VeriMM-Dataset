`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_input;
    reg rst;
    wire [7:0] predicted_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .current_input(current_input),
        .rst(rst),
        .predicted_output(predicted_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_input = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant Input", test_num);
            reset_dut();

            current_input = 8'd10;
            @(posedge clk);
            current_input = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Linear Increase", test_num);
            reset_dut();

            current_input = 8'd10;
            @(posedge clk);
            current_input = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Linear Decrease", test_num);
            reset_dut();

            current_input = 8'd50;
            @(posedge clk);
            current_input = 8'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-step Trend", test_num);
            reset_dut();

            current_input = 8'd10;
            @(posedge clk);
            current_input = 8'd15;
            @(posedge clk);
            current_input = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input", test_num);
            reset_dut();

            current_input = 8'd0;
            @(posedge clk);
            current_input = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [7:0] expected_predicted_output;
        begin
            if (expected_predicted_output === (expected_predicted_output ^ predicted_output ^ expected_predicted_output)) begin
                $display("PASS");
                $display("  Outputs: predicted_output=%h",
                         predicted_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_output=%h",
                         expected_predicted_output);
                $display("  Got:      predicted_output=%h",
                         predicted_output);
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
        $dumpvars(0,clk, current_input, rst, predicted_output);
    end

endmodule
