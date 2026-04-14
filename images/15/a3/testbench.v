`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg req2;
    reg reset;
    wire grant;

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
        .reset(reset),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req0 = 0;
            req1 = 0;
            req2 = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            req0 = 1;
            req1 = 0;
            req2 = 0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Only req0 active");
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            req0 = 0;
            req1 = 1;
            req2 = 0;
            @(posedge clk);
            #1;
            $display("Test Case 002: Only req1 active");
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            req0 = 0;
            req1 = 0;
            req2 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 003: Only req2 active");
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            req0 = 1;
            req1 = 1;
            req2 = 0;
            @(posedge clk);
            #1;
            $display("Test Case 004: req0 and req1 active (Priority req0)");
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            req0 = 0;
            req1 = 1;
            req2 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 005: req1 and req2 active (Priority req1)");
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            req0 = 1;
            req1 = 0;
            req2 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 006: req0 and req2 active (Priority req0)");
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            req0 = 1;
            req1 = 1;
            req2 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 007: All requests active (Priority req0)");
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            req0 = 0;
            req1 = 0;
            req2 = 0;
            @(posedge clk);
            #1;
            $display("Test Case 008: No requests active");
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase009;

        begin
            req0 = 1;
            req1 = 1;
            reset = 1;
            @(posedge clk);
            #1;
            $display("Test Case 009: Reset active with requests");
            #1;

            check_outputs(3'b000);
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
        testcase009();
        
        
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
        input expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%b",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%b",
                         expected_grant);
                $display("  Got:      grant=%b",
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, req0, req1, req2, reset, grant);
    end

endmodule
