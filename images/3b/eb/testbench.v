`timescale 1ns/1ps

module NVMe_Controller_Status_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg command_done;
    reg command_received;
    reg error_detected;
    reg reset;
    wire [2:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMe_Controller_Status dut (
        .clk(clk),
        .command_done(command_done),
        .command_received(command_received),
        .error_detected(error_detected),
        .reset(reset),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            command_received = 0;
            command_done = 0;
            error_detected = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Command Received (Busy=1, Ready=0)", test_num);
            reset_dut();
            command_received = 1;
            @(posedge clk);
            #1 command_received = 0;
            @(posedge clk);

            #1;


            check_outputs(3'b100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Command Completion (Busy=0, Ready=1)", test_num);
            reset_dut();

            command_received = 1;
            @(posedge clk);
            #1 command_received = 0;

            command_done = 1;
            @(posedge clk);
            #1 command_done = 0;
            @(posedge clk);

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Error Detection while Idle", test_num);
            reset_dut();
            error_detected = 1;
            @(posedge clk);
            #1 error_detected = 0;
            @(posedge clk);

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Error Detection while Busy", test_num);
            reset_dut();

            command_received = 1;
            @(posedge clk);
            #1 command_received = 0;

            error_detected = 1;
            @(posedge clk);
            #1 error_detected = 0;
            @(posedge clk);

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Ready to Busy Transition", test_num);
            reset_dut();

            command_received = 1;
            @(posedge clk);
            #1 command_received = 0;
            command_done = 1;
            @(posedge clk);
            #1 command_done = 0;

            command_received = 1;
            @(posedge clk);
            #1 command_received = 0;
            @(posedge clk);

            #1;


            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Error Detection while Ready", test_num);
            reset_dut();

            command_received = 1;
            @(posedge clk);
            #1 command_received = 0;
            command_done = 1;
            @(posedge clk);
            #1 command_done = 0;

            error_detected = 1;
            @(posedge clk);
            #1 error_detected = 0;
            @(posedge clk);

            #1;


            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMe_Controller_Status Testbench");
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
        input [2:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,clk, command_done, command_received, error_detected, reset, status);
    end

endmodule
