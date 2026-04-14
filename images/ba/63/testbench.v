`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Simple addition (1 + 2, cin=0)", test_num);
        a = 4'd1; b = 4'd2; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'd3);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Addition with cin (5 + 5, cin=1)", test_num);
        a = 4'd5; b = 4'd5; cin = 1'b1;
        #1;

        check_outputs(1'b0, 4'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Zero inputs", test_num);
        a = 4'd0; b = 4'd0; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Max sum without carry-out (15 + 0, cin=0)", test_num);
        a = 4'hF; b = 4'h0; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Generate carry-out (8 + 8, cin=0)", test_num);
        a = 4'd8; b = 4'd8; cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Carry-out from all inputs (15 + 1, cin=0)", test_num);
        a = 4'hF; b = 4'h1; cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Max values (15 + 15, cin=1)", test_num);
        a = 4'hF; b = 4'hF; cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Alternating bit patterns (10 + 5, cin=0)", test_num);
        a = 4'b1010; b = 4'b0101; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
