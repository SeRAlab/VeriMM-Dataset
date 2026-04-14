`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] index;
    wire [7:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .index(index),
        .value(value)
    );
    task testcase001;

    begin
        $display("Running Testcase 001: Access Index 0");
        index = 3'd0;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Access Index 1");
        index = 3'd1;
        #1;

        check_outputs(8'h14);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Access Index 2");
        index = 3'd2;
        #1;

        check_outputs(8'h1E);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Access Index 3");
        index = 3'd3;
        #1;

        check_outputs(8'h28);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Access Index 4");
        index = 3'd4;
        #1;

        check_outputs(8'h32);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Access Out-of-Bounds Index 5");
        index = 3'd5;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        $display("Running Testcase 007: Access Out-of-Bounds Index 7");
        index = 3'd7;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        input [7:0] expected_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: value=%h",
                         value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h",
                         expected_value);
                $display("  Got:      value=%h",
                         value);
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
