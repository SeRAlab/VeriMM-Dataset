`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    reg rst;
    wire grant0;
    wire grant1;
    wire grant2;
    wire grant3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .rst(rst),
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
            rst = 1;
            req0 = 0;
            req1 = 0;
            req2 = 0;
            req3 = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: No requests active", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single request req0", test_num);
            reset_dut();
            req0 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single request req1", test_num);
            reset_dut();
            req1 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Single request req2", test_num);
            reset_dut();
            req2 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Single request req3", test_num);
            reset_dut();
            req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Overlapping req0 and req3", test_num);
            reset_dut();
            req0 = 1;
            req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Overlapping req1, req2, and req3", test_num);
            reset_dut();
            req1 = 1;
            req2 = 1;
            req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: All requests active", test_num);
            reset_dut();
            req0 = 1;
            req1 = 1;
            req2 = 1;
            req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
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
        $dumpvars(0,clk, req0, req1, req2, req3, rst, grant0, grant1, grant2, grant3);
    end

endmodule
