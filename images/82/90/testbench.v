`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in5;
    wire [6:0] hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in5(in5),
        .hex(hex)
    );
    task testcase001;

    begin
        $display("\nRunning testcase001: Standard Values 0-4");
        in5 = 5'd0; #1;
 check_outputs(7'h3f);
        in5 = 5'd1; #1;
 check_outputs(7'h06);
        in5 = 5'd2; #1;
 check_outputs(7'h5b);
        in5 = 5'd3; #1;
 check_outputs(7'h4f);
        in5 = 5'd4; #1;
 check_outputs(7'h66);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Standard Values 5-9");
        in5 = 5'd5; #1;
 check_outputs(7'h6d);
        in5 = 5'd6; #1;
 check_outputs(7'h7d);
        in5 = 5'd7; #1;
 check_outputs(7'h07);
        in5 = 5'd8; #1;
 check_outputs(7'h7f);
        in5 = 5'd9; #1;
 check_outputs(7'h6f);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Hex Values A-F");
        in5 = 5'd10; #1;
 check_outputs(7'h77);
        in5 = 5'd11; #1;
 check_outputs(7'h7c);
        in5 = 5'd12; #1;
 check_outputs(7'h39);
        in5 = 5'd13; #1;
 check_outputs(7'h5e);
        in5 = 5'd14; #1;
 check_outputs(7'h79);
        in5 = 5'd15; #1;
 check_outputs(7'h71);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Special Case (Decimal 17)");
        in5 = 5'd17;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Unrecognized/Default Inputs");
        in5 = 5'd16; #1;
 check_outputs(7'h00);
        in5 = 5'd18; #1;
 check_outputs(7'h00);
        in5 = 5'd31; #1;
 check_outputs(7'h00);
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
        input [6:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
