`timescale 1ns/1ps

module NVMe_Controller_Status_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error;
    reg [2:0] operational_mode_in;
    reg ready;
    reg reset;
    wire error_status;
    wire [2:0] operational_mode;
    wire ready_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMe_Controller_Status_Register dut (
        .clk(clk),
        .error(error),
        .operational_mode_in(operational_mode_in),
        .ready(ready),
        .reset(reset),
        .error_status(error_status),
        .operational_mode(operational_mode),
        .ready_status(ready_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            error = 0;
            operational_mode_in = 3'b000;
            ready = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition to Active Mode", test_num);
            reset_dut();
            operational_mode_in = 3'b001;
            ready = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition to Maintenance Mode", test_num);
            reset_dut();
            operational_mode_in = 3'b010;
            ready = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Error Occurs during Active Mode", test_num);
            reset_dut();

            operational_mode_in = 3'b001;
            ready = 1;
            @(posedge clk);
            #1;

            error = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Error Occurs during Maintenance Mode", test_num);
            reset_dut();

            operational_mode_in = 3'b010;
            ready = 1;
            @(posedge clk);
            #1;

            error = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Ready Status Toggle", test_num);
            reset_dut();
            operational_mode_in = 3'b001;
            ready = 1;
            @(posedge clk);
            #1;
            ready = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b001, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Recovery Attempt While Error persists", test_num);
            reset_dut();
            error = 1;
            operational_mode_in = 3'b001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMe_Controller_Status_Register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_error_status;
        input [2:0] expected_operational_mode;
        input expected_ready_status;
        begin
            if (expected_error_status === (expected_error_status ^ error_status ^ expected_error_status) &&
                expected_operational_mode === (expected_operational_mode ^ operational_mode ^ expected_operational_mode) &&
                expected_ready_status === (expected_ready_status ^ ready_status ^ expected_ready_status)) begin
                $display("PASS");
                $display("  Outputs: error_status=%b, operational_mode=%h, ready_status=%b",
                         error_status, operational_mode, ready_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_status=%b, operational_mode=%h, ready_status=%b",
                         expected_error_status, expected_operational_mode, expected_ready_status);
                $display("  Got:      error_status=%b, operational_mode=%h, ready_status=%b",
                         error_status, operational_mode, ready_status);
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
        $dumpvars(0,clk, error, operational_mode_in, ready, reset, error_status, operational_mode, ready_status);
    end

endmodule
