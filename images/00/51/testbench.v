`timescale 1ns/1ps

module priority_arbiter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] req;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_arbiter dut (
        .req(req),
        .grant(grant)
    );
    task testcase001;

        begin
            $display("Testcase 001: No requests active");
            req = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single request - req[0] (Highest Priority)");
            req = 4'b0001;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single request - req[1]");
            req = 4'b0010;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Single request - req[2]");
            req = 4'b0100;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single request - req[3] (Lowest Priority)");
            req = 4'b1000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple requests - req[0] and req[1] (req[0] should win)");
            req = 4'b0011;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple requests - req[1] and req[2] (req[1] should win)");
            req = 4'b0110;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Multiple requests - req[2] and req[3] (req[2] should win)");
            req = 4'b1100;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Multiple requests - req[0] and req[3] (req[0] should win)");
            req = 4'b1001;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: All requests active (req[0] should win)");
            req = 4'b1111;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: req[1], req[2], req[3] active (req[1] should win)");
            req = 4'b1110;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_arbiter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [3:0] expected_grant;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%h",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h",
                         expected_grant);
                $display("  Got:      grant=%h",
                         grant);
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
