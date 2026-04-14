`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] REQ;
    reg RST;
    wire GRANT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .REQ(REQ),
        .RST(RST),
        .GRANT(GRANT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            REQ = 4'b0000;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            REQ = 4'b0001;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            REQ = 4'b1000;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            REQ = 4'b0011;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            REQ = 4'b1010;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            REQ = 4'b1111;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            REQ = 4'b0100;
            @(posedge CLK);
            REQ = 4'b0000;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            REQ = 4'b0100;
            @(posedge CLK);
            REQ = 4'b0101;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b0001);
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
        input expected_GRANT;
        begin
            if (expected_GRANT === (expected_GRANT ^ GRANT ^ expected_GRANT)) begin
                $display("PASS");
                $display("  Outputs: GRANT=%b",
                         GRANT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRANT=%b",
                         expected_GRANT);
                $display("  Got:      GRANT=%b",
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
        $dumpvars(0,CLK, REQ, RST, GRANT);
    end

endmodule
