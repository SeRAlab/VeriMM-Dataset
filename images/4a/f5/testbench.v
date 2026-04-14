`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg [63:0] cin;
    wire [63:0] ca;
    wire [63:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .ca(ca),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 64'h0; b = 64'h0; cin = 64'h0;
        #1;

        check_outputs(64'h0, 64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'hFFFFFFFFFFFFFFFF;
        cin = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFE, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 64'h5555555555555555;
        b = 64'hAAAAAAAAAAAAAAAA;
        cin = 64'h0;
        #1;

        check_outputs(64'h0, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 64'h1; b = 64'h1; cin = 64'h1;
        #1;

        check_outputs(64'h2, 64'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 64'h2; b = 64'h2; cin = 64'h2;
        #1;

        check_outputs(64'h4, 64'h2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 64'h4000000000000000;
        b = 64'h4000000000000000;
        cin = 64'h0;
        #1;

        check_outputs(64'h8000000000000000, 64'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 64'h8000000000000000;
        b = 64'h8000000000000000;
        cin = 64'h0;
        #1;

        check_outputs(64'h0, 64'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'h0;
        cin = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFE, 64'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 64'h123456789ABCDEF0;
        b = 64'h0; cin = 64'h0;
        #1;

        check_outputs(64'h0, 64'h123456789ABCDEF0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 64'h00000000FFFFFFFF;
        b = 64'h00000000FFFFFFFF;
        cin = 64'h00000000FFFFFFFF;
        #1;

        check_outputs(64'h00000001FFFFFFFE, 64'h00000000FFFFFFFF);
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
        input [63:0] expected_ca;
        input [63:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ca === (expected_ca ^ ca ^ expected_ca) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: ca=%h, sum=%h",
                         ca, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ca=%h, sum=%h",
                         expected_ca, expected_sum);
                $display("  Got:      ca=%h, sum=%h",
                         ca, sum);
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
