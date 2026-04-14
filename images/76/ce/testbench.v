`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in_a;
    reg [15:0] in_b;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_a(in_a),
        .in_b(in_b),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in_a = 16'h0000;
        in_b = 16'h0000;
        $display("Test %0d: Concatenate all zeros", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in_a = 16'hFFFF;
        in_b = 16'hFFFF;
        $display("Test %0d: Concatenate all ones", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in_a = 16'h1234;
        in_b = 16'h5678;
        $display("Test %0d: Standard concatenation", test_num);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in_a = 16'hAAAA;
        in_b = 16'h5555;
        $display("Test %0d: Alternating bit patterns", test_num);
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in_a = 16'hDEAD;
        in_b = 16'hBEEF;
        $display("Test %0d: Concatenate hex words", test_num);
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in_a = 16'h000F;
        in_b = 16'hF000;
        $display("Test %0d: Small and large 16-bit values", test_num);
        #1;

        check_outputs(32'h000FF000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in_a = 16'h8000;
        in_b = 16'h0001;
        $display("Test %0d: MSB and LSB logic", test_num);
        #1;

        check_outputs(32'h80000001);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
