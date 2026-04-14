`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error_detected;
    reg reset;
    reg start_receive;
    reg start_transmit;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .error_detected(error_detected),
        .reset(reset),
        .start_receive(start_receive),
        .start_transmit(start_transmit),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_transmit = 0;
            start_receive = 0;
            error_detected = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IDLE to TRANSMIT", test_num);
            reset_dut();
            @(posedge clk);
            start_transmit = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(TRANSMIT);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: IDLE to RECEIVE", test_num);
            reset_dut();
            @(posedge clk);
            start_receive = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(RECEIVE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: TRANSMIT to ERROR", test_num);
            reset_dut();

            @(posedge clk);
            start_transmit = 1;
            @(posedge clk);

            @(posedge clk);
            error_detected = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(ERROR);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: RECEIVE to ERROR", test_num);
            reset_dut();

            @(posedge clk);
            start_receive = 1;
            @(posedge clk);

            @(posedge clk);
            error_detected = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(ERROR);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: IDLE to ERROR", test_num);
            reset_dut();
            @(posedge clk);
            error_detected = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(ERROR);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Recovery from ERROR to IDLE", test_num);
            reset_dut();

            error_detected = 1;
            @(posedge clk);

            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Return to IDLE from TRANSMIT", test_num);
            reset_dut();

            start_transmit = 1;
            @(posedge clk);

            start_transmit = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, error_detected, reset, start_receive, start_transmit, state);
    end

endmodule
