`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] h_p;
    reg [3:0] v_p;
    wire [4:0] num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h_p(h_p),
        .v_p(v_p),
        .num(num)
    );
    task testcase001;

    begin
        h_p = 4'd0; v_p = 4'd0; #1;
 check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        h_p = 4'd1; v_p = 4'd0; #1;
 check_outputs(5'd1);
    end
        endtask

    task testcase003;

    begin
        h_p = 4'd2; v_p = 4'd0; #1;
 check_outputs(5'd2);
    end
        endtask

    task testcase004;

    begin
        h_p = 4'd3; v_p = 4'd0; #1;
 check_outputs(5'd3);
    end
        endtask

    task testcase005;

    begin
        h_p = 4'd0; v_p = 4'd1; #1;
 check_outputs(5'd4);
    end
        endtask

    task testcase006;

    begin
        h_p = 4'd1; v_p = 4'd1; #1;
 check_outputs(5'd5);
    end
        endtask

    task testcase007;

    begin
        h_p = 4'd2; v_p = 4'd1; #1;
 check_outputs(5'd6);
    end
        endtask

    task testcase008;

    begin
        h_p = 4'd3; v_p = 4'd1; #1;
 check_outputs(5'd7);
    end
        endtask

    task testcase009;

    begin
        h_p = 4'd0; v_p = 4'd2; #1;
 check_outputs(5'd8);
    end
        endtask

    task testcase010;

    begin
        h_p = 4'd1; v_p = 4'd2; #1;
 check_outputs(5'd9);
    end
        endtask

    task testcase011;

    begin
        h_p = 4'd2; v_p = 4'd2; #1;
 check_outputs(5'd10);
    end
        endtask

    task testcase012;

    begin
        h_p = 4'd3; v_p = 4'd2; #1;
 check_outputs(5'd11);
    end
        endtask

    task testcase013;

    begin
        h_p = 4'd0; v_p = 4'd3; #1;
 check_outputs(5'd12);
    end
        endtask

    task testcase014;

    begin
        h_p = 4'd1; v_p = 4'd3; #1;
 check_outputs(5'd13);
    end
        endtask

    task testcase015;

    begin
        h_p = 4'd2; v_p = 4'd3; #1;
 check_outputs(5'd14);
    end
        endtask

    task testcase016;

    begin
        h_p = 4'd3; v_p = 4'd3; #1;
 check_outputs(5'd15);
    end
        endtask

    task testcase017;

    begin
        h_p = 4'd4; v_p = 4'd0; #1;
 check_outputs(5'd16);
    end
        endtask

    task testcase018;

    begin
        h_p = 4'd0; v_p = 4'd4; #1;
 check_outputs(5'd16);
    end
        endtask

    task testcase019;

    begin
        h_p = 4'd15; v_p = 4'd15; #1;
 check_outputs(5'd16);
    end
        endtask

    task testcase020;

    begin
        h_p = 4'd3; v_p = 4'd5; #1;
 check_outputs(5'd16);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        testcase019();
        testcase020();
        
        
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
        input [4:0] expected_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num === (expected_num ^ num ^ expected_num)) begin
                $display("PASS");
                $display("  Outputs: num=%h",
                         num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num=%h",
                         expected_num);
                $display("  Got:      num=%h",
                         num);
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
