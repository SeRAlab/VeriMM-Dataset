`timescale 1ns/1ps

module ForwardingUnit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest;
    reg regWrite;
    reg [4:0] src1;
    reg [4:0] src2;
    wire forwardA;
    wire forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ForwardingUnit dut (
        .dest(dest),
        .regWrite(regWrite),
        .src1(src1),
        .src2(src2),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Forwarding to Source 1");
            dest = 5'd10;
            regWrite = 1'b1;
            src1 = 5'd10;
            src2 = 5'd5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Forwarding to Source 2");
            dest = 5'd15;
            regWrite = 1'b1;
            src1 = 5'd2;
            src2 = 5'd15;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Forwarding to both Source 1 and Source 2");
            dest = 5'd7;
            regWrite = 1'b1;
            src1 = 5'd7;
            src2 = 5'd7;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: No register match");
            dest = 5'd20;
            regWrite = 1'b1;
            src1 = 5'd21;
            src2 = 5'd22;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Match exists but RegWrite is 0");
            dest = 5'd4;
            regWrite = 1'b0;
            src1 = 5'd4;
            src2 = 5'd4;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Destination is Register 0 (should not forward)");
            dest = 5'd0;
            regWrite = 1'b1;
            src1 = 5'd0;
            src2 = 5'd0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Match on Register 31");
            dest = 5'd31;
            regWrite = 1'b1;
            src1 = 5'd31;
            src2 = 5'd0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ForwardingUnit Testbench");
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
        input expected_forwardA;
        input expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%b, forwardB=%b",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
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
