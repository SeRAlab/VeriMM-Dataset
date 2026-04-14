`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] command;
    wire [2:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .command(command),
        .status(status)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Command 0 (Idle)", test_num);
            command = 5'b00000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Command 1 (Ready)", test_num);
            command = 5'b00001;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Command 2 (Processing)", test_num);
            command = 5'b00010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Command 3 (Completed)", test_num);
            command = 5'b00011;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Command 4 (Error)", test_num);
            command = 5'b00100;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Command 5 (Unknown)", test_num);
            command = 5'b00101;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Command 31 (Unknown/Boundary)", test_num);
            command = 5'b11111;
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
        input [2:0] expected_status;
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
