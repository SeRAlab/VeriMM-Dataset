`timescale 1ns/1ps

module four_to_one_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_to_one dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out(out)
    );
    task testcase001;

    begin
        $display("Testcase 001: Testing in1 = 1 (Priority 1)");
        in1 = 1'b1; in2 = 1'b0; in3 = 1'b0; in4 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Testing in1 = 0, in2 = 1 (Priority 2)");
        in1 = 1'b0; in2 = 1'b1; in3 = 1'b0; in4 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Testing in1 = 0, in2 = 0, in3 = 1 (Priority 3)");
        in1 = 1'b0; in2 = 1'b0; in3 = 1'b1; in4 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Testing all inputs = 0");
        in1 = 1'b0; in2 = 1'b0; in3 = 1'b0; in4 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Testing multiple inputs active (in1 should dominate)");
        in1 = 1'b1; in2 = 1'b1; in3 = 1'b1; in4 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Testing in2 and in3 active while in1 is 0");
        in1 = 1'b0; in2 = 1'b1; in3 = 1'b1; in4 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Testing in1 active, others random");
        in1 = 1'b1; in2 = 1'b0; in3 = 1'b1; in4 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_to_one Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
