`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg cin;
    wire cout;
    wire [63:0] result;

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
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (No Carry)", test_num);
            a = 64'h0000_0000_0000_0005;
            b = 64'h0000_0000_0000_000A;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (With cin)", test_num);
            a = 64'h0000_0000_0000_0005;
            b = 64'h0000_0000_0000_000A;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Overflow (Result should be 0, cout=1)", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0001;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Overflow via cin", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0000;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition of large numbers", test_num);
            a = 64'h7FFFFFFF_FFFFFFFF;
            b = 64'h7FFFFFFF_FFFFFFFF;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFF_FFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns", test_num);
            a = 64'h5555_5555_5555_5555;
            b = 64'hAAAA_AAAA_AAAA_AAAA;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns with cin", test_num);
            a = 64'h5555_5555_5555_5555;
            b = 64'hAAAA_AAAA_AAAA_AAAA;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Internal carry propagation check", test_num);
            a = 64'h0000_0000_FFFF_FFFF;
            b = 64'h0000_0000_0000_0001;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 64'h0000_0001_0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values + cin", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'hFFFF_FFFF_FFFF_FFFF;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-bit carry check", test_num);
            a = 64'h8000_0000_0000_0000;
            b = 64'h8000_0000_0000_0000;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
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
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, result=%h",
                         cout, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, result=%h",
                         expected_cout, expected_result);
                $display("  Got:      cout=%b, result=%h",
                         cout, result);
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
