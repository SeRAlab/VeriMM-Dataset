`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] ctrl;
    wire [15:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .p(p)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'sd10;
        b = 8'sd5;
        ctrl = 4'd0;
        #10;

        #1;


        check_outputs(16'sd50);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = -8'sd12;
        b = 8'sd4;
        ctrl = 4'd0;
        #10;

        #1;


        check_outputs(-16'sd48);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = -8'sd8;
        b = -8'sd7;
        ctrl = 4'd0;
        #10;

        #1;


        check_outputs(16'sd56);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'sd0;
        b = -8'sd128;
        ctrl = 4'd0;
        #10;

        #1;


        check_outputs(16'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'sd127;
        b = 8'sd127;
        ctrl = 4'd0;
        #10;

        #1;


        check_outputs(16'sd16129);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = -8'sd128;
        b = -8'sd128;
        ctrl = 4'd0;
        #10;

        #1;


        check_outputs(16'sd16384);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'sd10;
        b = 8'sd10;
        ctrl = 4'd15;
        #10;

        #1;


        check_outputs(16'sd115);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = -8'sd128;
        b = 8'sd127;
        ctrl = 4'd0;
        #10;

        #1;


        check_outputs(-16'sd16256);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 8'sd127;
        b = 8'sd127;
        ctrl = 4'd1;
        #10;

        #1;


        check_outputs(16'sd16130);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = -8'sd128;
        b = 8'sd127;
        ctrl = 4'd10;
        #10;

        #1;


        check_outputs(-16'sd16246);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
