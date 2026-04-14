`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg cin;
    wire cout;
    wire [31:0] sum;

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
            test_num = test_num + 1;
            $display("Testcase %0d: Simple addition without carry", test_num);
            a = 32'h0000_0005;
            b = 32'h0000_000A;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with carry-in", test_num);
            a = 32'h0000_0001;
            b = 32'h0000_0001;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 32'h0000_0003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Generate carry-out from MSB", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones plus carry-in", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0000;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns (no carry-out)", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns with carry-in (triggers carry-out)", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum sum possible", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition of zero", test_num);
            a = 32'h0000_0000;
            b = 32'h0000_0000;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random values test", test_num);
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            cin = 1'b0;

            #1;


            check_outputs(1'b0, 32'h9999_9999);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Internal carry propagation test", test_num);
            a = 32'h0000_FFFF;
            b = 32'h0000_0001;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h0001_0000);
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
        input [31:0] expected_sum;
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
