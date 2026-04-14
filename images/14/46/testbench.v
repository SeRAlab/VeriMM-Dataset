`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_request;
    reg data_valid;
    reg rst;
    reg start;
    wire error;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .data_request(data_request),
        .data_valid(data_valid),
        .rst(rst),
        .start(start),
        .error(error),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_request = 0;
            data_valid = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset and IDLE state check", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition IDLE to ACTIVE", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, ACTIVE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Active state with valid data processing", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            data_request = 1;
            data_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, ACTIVE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition ACTIVE to ERROR (data_valid low)", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1 data_request = 1;
            data_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, ERROR);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data request ignored in IDLE", test_num);
            reset_dut();
            data_request = 1;
            data_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Recovery from ERROR via Reset", test_num);
            reset_dut();

            start = 1; @(posedge clk);
            #1 start = 0; data_request = 1; data_valid = 0;
            @(posedge clk); #1;

            reset_dut();
            #1;

            check_outputs(1'b0, IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input expected_error;
        input [1:0] expected_state;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: error=%b, state=%h",
                         error, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, state=%h",
                         expected_error, expected_state);
                $display("  Got:      error=%b, state=%h",
                         error, state);
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
        $dumpvars(0,clk, data_request, data_valid, rst, start, error, state);
    end

endmodule
