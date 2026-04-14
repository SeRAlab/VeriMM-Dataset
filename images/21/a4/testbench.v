`timescale 1ns/1ps

module bluetooth_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] status;
    wire [2:0] status_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_controller dut (
        .status(status),
        .status_code(status_code)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: OFF status (0000 -> 000)", test_num);
            status = 4'b0000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: CONNECTING status (0001 -> 001)", test_num);
            status = 4'b0001;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: CONNECTED status (0010 -> 010)", test_num);
            status = 4'b0010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: DISCONNECTED status (0011 -> 011)", test_num);
            status = 4'b0011;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: ERROR status (0100 -> 100)", test_num);
            status = 4'b0100;
            #1;

            check_outputs(3'b100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_controller Testbench");
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
        input [2:0] expected_status_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status_code === (expected_status_code ^ status_code ^ expected_status_code)) begin
                $display("PASS");
                $display("  Outputs: status_code=%h",
                         status_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status_code=%h",
                         expected_status_code);
                $display("  Got:      status_code=%h",
                         status_code);
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
