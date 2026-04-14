`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .req(req),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            req = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No requests", test_num);
            reset_dut();
            req = 4'b0000;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single request (Bit 0)", test_num);
            reset_dut();
            req = 4'b0001;

            repeat(5) begin
                if (grant == 4'b0001) break;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single request (Bit 2)", test_num);
            reset_dut();
            req = 4'b0100;

            repeat(5) begin
                if (grant == 4'b0100) break;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        reg [3:0] first_grant;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests - transition check", test_num);
            reset_dut();
            req = 4'b1111;


            wait(grant != 0);
            first_grant = grant;


            @(posedge clk);
            #1;



            if (first_grant == 4'b0001)      #1;
      check_outputs(4'b0010);
            else if (first_grant == 4'b0010) #1;
 check_outputs(4'b0100);
            else if (first_grant == 4'b0100) #1;
 check_outputs(4'b1000);
            else if (first_grant == 4'b1000) #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Drop request mid-cycle", test_num);
            reset_dut();
            req = 4'b1000;

            repeat(5) begin
                if (grant == 4'b1000) break;
                @(posedge clk);
            end


            req = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Non-consecutive requests (Bits 0 and 2)", test_num);
            reset_dut();
            req = 4'b0101;


            repeat(5) begin
                if (grant == 4'b0100) break;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, req, grant);
    end

endmodule
