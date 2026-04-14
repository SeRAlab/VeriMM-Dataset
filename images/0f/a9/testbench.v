`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] req;
    reg rst;
    wire [4:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No requests", test_num);
            reset_dut();
            req = 5'b00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Highest priority request only (req[0])", test_num);
            reset_dut();
            req = 5'b00001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Lowest priority request only (req[4])", test_num);
            reset_dut();
            req = 5'b10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Multiple requests (all active), req[0] priority", test_num);
            reset_dut();
            req = 5'b11111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Requests on 2, 3, 4; req[2] should win", test_num);
            reset_dut();
            req = 5'b11100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Non-contiguous requests (1 and 3); req[1] should win", test_num);
            reset_dut();
            req = 5'b01010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Single request on req[3]", test_num);
            reset_dut();
            req = 5'b01000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Reset overrides requests", test_num);
            reset_dut();
            req = 5'b11111;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
            rst = 0;
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
        input [4:0] expected_grant;
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
        $dumpvars(0,clk, req, rst, grant);
    end

endmodule
