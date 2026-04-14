`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] request;
    reg reset;
    wire [1:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .request(request),
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
            request = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Requestor 0 Only", test_num);
            reset_dut();
            request = 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Requestor 1 Only", test_num);
            reset_dut();
            request = 4'b0010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Requestor 3 Only", test_num);
            reset_dut();
            request = 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Conflict Req 0 and 1 (0 Wins)", test_num);
            reset_dut();
            request = 4'b0011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Conflict Req 1 and 2 (1 Wins)", test_num);
            reset_dut();
            request = 4'b0110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Conflict Req 2 and 3 (2 Wins)", test_num);
            reset_dut();
            request = 4'b1100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Requestors Active (0 Wins)", test_num);
            reset_dut();
            request = 4'b1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Preemption (Req 2 then Req 0)", test_num);
            reset_dut();
            request = 4'b0100;
            @(posedge clk);
            #1 request = 4'b0101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
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
        input [1:0] expected_grant;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, request, reset, grant);
    end

endmodule
