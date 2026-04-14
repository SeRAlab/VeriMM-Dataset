`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg cin;
    wire cout;
    wire [31:0] y;

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
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h00000000; b = 32'h00000000; cin = 0;
            #1;

            check_outputs(0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'h00000005; b = 32'h0000000A; cin = 0;
            #1;

            check_outputs(0, 32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h00000001; b = 32'h00000001; cin = 1;
            #1;

            check_outputs(0, 32'h00000003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hFFFFFFFE; b = 32'h00000001; cin = 0;
            #1;

            check_outputs(0, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hFFFFFFFF; b = 32'h00000001; cin = 0;
            #1;

            check_outputs(1, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hFFFFFFFF; b = 32'h00000000; cin = 1;
            #1;

            check_outputs(1, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'hAAAAAAAA; b = 32'h55555555; cin = 0;
            #1;

            check_outputs(0, 32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; cin = 1;
            #1;

            check_outputs(1, 32'hFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'h12345678; b = 32'h87654321; cin = 0;
            #1;

            check_outputs(0, 32'h99999999);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'h80000000; b = 32'h80000000; cin = 0;
            #1;

            check_outputs(1, 32'h00000000);
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
        input expected_cout;
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, y=%h",
                         cout, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, y=%h",
                         expected_cout, expected_y);
                $display("  Got:      cout=%b, y=%h",
                         cout, y);
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
