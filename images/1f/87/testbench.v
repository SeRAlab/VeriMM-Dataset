`timescale 1ns/1ps

module round_robin_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] request;
    reg rst;
    wire [2:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    round_robin_arbiter dut (
        .clk(clk),
        .request(request),
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
        request = 3'b000;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Single request channel 0");
        reset_dut();
        request = 3'b001;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single request channel 1");
        reset_dut();
        request = 3'b010;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Single request channel 2");
        reset_dut();
        request = 3'b100;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Priority rotation (0 then 1)");
        reset_dut();
        request = 3'b111;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Priority rotation (0 then 1 then 2)");
        reset_dut();
        request = 3'b111;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Skip idle requester (0 then 2)");
        reset_dut();
        request = 3'b001;
        @(posedge clk);
        #1;
        request = 3'b100;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Wrap around from 2 to 0");
        reset_dut();
        request = 3'b100;
        @(posedge clk);
        #1;
        request = 3'b111;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: No requests");
        reset_dut();
        request = 3'b000;
        @(posedge clk);
        #1 #1;
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
        input [2:0] expected_grant;
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
        $dumpvars(0,clk, request, rst, grant);
    end

endmodule
