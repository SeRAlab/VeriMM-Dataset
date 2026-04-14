`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] REQ;
    reg clk;
    reg reset;
    wire [3:0] GRANT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .REQ(REQ),
        .clk(clk),
        .reset(reset),
        .GRANT(GRANT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            REQ = 4'b0000;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request REQ[3] (Highest Priority)", test_num);
            reset_dut();
            REQ = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (REQ[2] and REQ[0]), REQ[2] should win", test_num);
            reset_dut();
            REQ = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stickiness - REQ[1] holds grant while REQ[3] arrives", test_num);
            reset_dut();

            REQ = 4'b0010;
            @(posedge clk);
            #1;

            REQ = 4'b1010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-arbitration - REQ[1] releases, REQ[3] should get grant", test_num);
            reset_dut();

            REQ = 4'b0010;
            @(posedge clk);
            #1;

            REQ = 4'b1010;
            @(posedge clk);
            #1;

            REQ = 4'b1000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single lowest priority request (REQ[0])", test_num);
            reset_dut();
            REQ = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No requests, no grants", test_num);
            reset_dut();
            REQ = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active grant", test_num);
            reset_dut();
            REQ = 4'b1000;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
            reset = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Release/Grant sequence", test_num);
            reset_dut();

            REQ = 4'b0011;
            @(posedge clk);
            #1;

            REQ = 4'b1111;
            @(posedge clk);
            #1;

            REQ = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
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
        input [3:0] expected_GRANT;
        begin
            if (expected_GRANT === (expected_GRANT ^ GRANT ^ expected_GRANT)) begin
                $display("PASS");
                $display("  Outputs: GRANT=%h",
                         GRANT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRANT=%h",
                         expected_GRANT);
                $display("  Got:      GRANT=%h",
                         GRANT);
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
        $dumpvars(0,REQ, clk, reset, GRANT);
    end

endmodule
