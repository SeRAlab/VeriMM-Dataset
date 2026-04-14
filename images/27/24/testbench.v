`timescale 1ns/1ps

module bluetooth_status_checker_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] status;
    wire [2:0] encoded_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_status_checker dut (
        .status(status),
        .encoded_status(encoded_status)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Status = 00 (Off)");
            status = 2'b00;
            #10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Status = 01 (Connecting)");
            status = 2'b01;
            #10;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Status = 10 (Connected)");
            status = 2'b10;
            #10;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Status = 11 (Error)");
            status = 2'b11;
            #10;
            #1;

            check_outputs(3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_status_checker Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [2:0] expected_encoded_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_status === (expected_encoded_status ^ encoded_status ^ expected_encoded_status)) begin
                $display("PASS");
                $display("  Outputs: encoded_status=%h",
                         encoded_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_status=%h",
                         expected_encoded_status);
                $display("  Got:      encoded_status=%h",
                         encoded_status);
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

endmodule
