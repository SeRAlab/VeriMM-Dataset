`timescale 1ns/1ps

module round_robin_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg request0;
    reg request1;
    reg request2;
    reg request3;
    reg reset;
    wire grant0;
    wire grant1;
    wire grant2;
    wire grant3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    round_robin_arbiter dut (
        .clk(clk),
        .request0(request0),
        .request1(request1),
        .request2(request2),
        .request3(request3),
        .reset(reset),
        .grant0(grant0),
        .grant1(grant1),
        .grant2(grant2),
        .grant3(grant3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request0 = 0;
            request1 = 0;
            request2 = 0;
            request3 = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: No requests after reset", test_num);
            reset_dut();
            request0 = 0;
            request1 = 0;
            request2 = 0;
            request3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single request on channel 2", test_num);
            reset_dut();
            request2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple requests (0 and 3) - Request 0 should win", test_num);
            reset_dut();
            request0 = 1;
            request3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Priority Rotation - Request 0 wins, then Request 1 should win", test_num);
            reset_dut();

            request0 = 1;
            request1 = 1;
            @(posedge clk);
            #2;

            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Priority Rotation - Skip request 1 and 2 to grant 3", test_num);
            reset_dut();

            request0 = 1;
            request3 = 1;
            @(posedge clk);
            #2;

            request0 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Full Rotation Cycle (0->1->2->3)", test_num);
            reset_dut();
            request0 = 1;
            request1 = 1;
            request2 = 1;
            request3 = 1;


            @(posedge clk);
            #2;
            @(posedge clk);
            #2;
            @(posedge clk);
            #2;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Wraparound (3 back to 0)", test_num);
            reset_dut();
            request0 = 1;
            request1 = 1;
            request2 = 1;
            request3 = 1;


            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Request 1 persists while others toggle", test_num);
            reset_dut();
            request1 = 1;
            request0 = 1;

            @(posedge clk);
            #2;
            request0 = 0;
            request2 = 1;
            @(posedge clk);
            #2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("round_robin_arbiter Testbench");
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
        input expected_grant0;
        input expected_grant1;
        input expected_grant2;
        input expected_grant3;
        begin
            if (expected_grant0 === (expected_grant0 ^ grant0 ^ expected_grant0) &&
                expected_grant1 === (expected_grant1 ^ grant1 ^ expected_grant1) &&
                expected_grant2 === (expected_grant2 ^ grant2 ^ expected_grant2) &&
                expected_grant3 === (expected_grant3 ^ grant3 ^ expected_grant3)) begin
                $display("PASS");
                $display("  Outputs: grant0=%b, grant1=%b, grant2=%b, grant3=%b",
                         grant0, grant1, grant2, grant3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant0=%b, grant1=%b, grant2=%b, grant3=%b",
                         expected_grant0, expected_grant1, expected_grant2, expected_grant3);
                $display("  Got:      grant0=%b, grant1=%b, grant2=%b, grant3=%b",
                         grant0, grant1, grant2, grant3);
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
        $dumpvars(0,clk, request0, request1, request2, request3, reset, grant0, grant1, grant2, grant3);
    end

endmodule
