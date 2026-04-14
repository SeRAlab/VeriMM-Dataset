`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest;
    reg [4:0] src1;
    reg [4:0] src2;
    reg valid;
    wire forward_src1;
    wire forward_src2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dest(dest),
        .src1(src1),
        .src2(src2),
        .valid(valid),
        .forward_src1(forward_src1),
        .forward_src2(forward_src2)
    );
    task testcase001;

        begin
            $display("Testcase 001: Valid signal low, registers match (No forwarding)");
            test_num = 1;
            valid = 0;
            dest = 5'd10;
            src1 = 5'd10;
            src2 = 5'd10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Valid high, src1 matches dest");
            test_num = 2;
            valid = 1;
            dest = 5'd15;
            src1 = 5'd15;
            src2 = 5'd20;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Valid high, src2 matches dest");
            test_num = 3;
            valid = 1;
            dest = 5'd25;
            src1 = 5'd5;
            src2 = 5'd25;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Valid high, both src1 and src2 match dest");
            test_num = 4;
            valid = 1;
            dest = 5'd8;
            src1 = 5'd8;
            src2 = 5'd8;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Valid high, no registers match");
            test_num = 5;
            valid = 1;
            dest = 5'd12;
            src1 = 5'd1;
            src2 = 5'd2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Boundary check (Reg 31)");
            test_num = 6;
            valid = 1;
            dest = 5'd31;
            src1 = 5'd31;
            src2 = 5'd0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Boundary check (Reg 0)");
            test_num = 7;
            valid = 1;
            dest = 5'd0;
            src1 = 5'd0;
            src2 = 5'd0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Toggle valid signal");
            test_num = 8;
            valid = 1;
            dest = 5'd7;
            src1 = 5'd7;
            src2 = 5'd0;
            #1;
            valid = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input expected_forward_src1;
        input expected_forward_src2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_src1 === (expected_forward_src1 ^ forward_src1 ^ expected_forward_src1) &&
                expected_forward_src2 === (expected_forward_src2 ^ forward_src2 ^ expected_forward_src2)) begin
                $display("PASS");
                $display("  Outputs: forward_src1=%b, forward_src2=%b",
                         forward_src1, forward_src2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_src1=%b, forward_src2=%b",
                         expected_forward_src1, expected_forward_src2);
                $display("  Got:      forward_src1=%b, forward_src2=%b",
                         forward_src1, forward_src2);
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
