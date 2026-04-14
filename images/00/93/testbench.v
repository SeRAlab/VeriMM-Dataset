`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] command;
    wire [4:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .command(command),
        .status(status)
    );
    task testcase001;

    begin
        test_num = 1;
        command = 5'b00000;
        $display("Test %0d: Command 00000 (SUCCESS)", test_num);
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        command = 5'b00001;
        $display("Test %0d: Command 00001 (ERROR)", test_num);
        #1;

        check_outputs(5'b11110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        command = 5'b00010;
        $display("Test %0d: Command 00010 (TIMEOUT)", test_num);
        #1;

        check_outputs(5'b11101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        command = 5'b00011;
        $display("Test %0d: Command 00011 (UNKNOWN boundary)", test_num);
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        command = 5'b11111;
        $display("Test %0d: Command 11111 (UNKNOWN boundary)", test_num);
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        command = 5'b01010;
        $display("Test %0d: Command 01010 (UNKNOWN random)", test_num);
        #1;

        check_outputs(5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller Testbench");
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
        input [4:0] expected_status;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
