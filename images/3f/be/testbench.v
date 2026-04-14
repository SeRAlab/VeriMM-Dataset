`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg complete_transmission;
    reg error_detected;
    reg reset;
    reg start_transmission;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .complete_transmission(complete_transmission),
        .error_detected(error_detected),
        .reset(reset),
        .start_transmission(start_transmission),
        .current_state(current_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_transmission = 0;
            complete_transmission = 0;
            error_detected = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE to ACTIVE via start_transmission", test_num);
            reset_dut();
            @(posedge clk);
            start_transmission = 1;
            @(posedge clk);
            #1 start_transmission = 0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ACTIVE to IDLE via complete_transmission", test_num);
            reset_dut();

            @(posedge clk);
            start_transmission = 1;
            @(posedge clk);
            #1 start_transmission = 0;

            complete_transmission = 1;
            @(posedge clk);
            #1 complete_transmission = 0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ACTIVE to ERROR via error_detected", test_num);
            reset_dut();

            @(posedge clk);
            start_transmission = 1;
            @(posedge clk);
            #1 start_transmission = 0;

            error_detected = 1;
            @(posedge clk);
            #1 error_detected = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE to ERROR via error_detected", test_num);
            reset_dut();

            error_detected = 1;
            @(posedge clk);
            #1 error_detected = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in ACTIVE state", test_num);
            reset_dut();
            @(posedge clk);
            start_transmission = 1;
            @(posedge clk);
            #1 start_transmission = 0;
            repeat (3) @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery from ERROR to IDLE via Reset", test_num);
            reset_dut();

            error_detected = 1;
            @(posedge clk);
            #1 error_detected = 0;

            if (current_state == 2'b10) begin

                reset = 1;
                @(posedge clk);
                #1 reset = 0;
                @(posedge clk);

                #1;


                check_outputs(2'b00);
            end else begin
                $display("Setup failed: Did not enter ERROR state");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        input [1:0] expected_current_state;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h",
                         current_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h",
                         expected_current_state);
                $display("  Got:      current_state=%h",
                         current_state);
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
        $dumpvars(0,clk, complete_transmission, error_detected, reset, start_transmission, current_state);
    end

endmodule
