`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [162:0] A;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .O(O)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        A = 163'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones", test_num);
        A = {163{1'b1}};
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Bit LSB", test_num);
        A = 163'b0;
        A[0] = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Bit MSB", test_num);
        A = 163'b0;
        A[162] = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits 0101", test_num);
        for(i=0; i<163; i=i+1) begin
            A[i] = (i % 2 == 0) ? 1'b1 : 1'b0;
        end
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits 1010", test_num);
        for(i=0; i<163; i=i+1) begin
            A[i] = (i % 2 == 1) ? 1'b1 : 1'b0;
        end
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    reg [162:0] val;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Pattern 1", test_num);
        val[31:0]   = 32'hA5A5_5A5A;
        val[63:32]  = 32'h1234_5678;
        val[95:64]  = 32'hDEAD_BEEF;
        val[127:96] = 32'hFFFF_0000;
        val[159:128]= 32'h8888_8888;
        val[162:160]= 3'b101;
        A = val;
        #1;

        check_outputs(^val);
    end
        endtask

    task testcase008;

    reg [162:0] val;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Pattern 2", test_num);
        val[31:0]   = 32'h0;
        val[63:32]  = 32'h0;
        val[95:64]  = 32'h0;
        val[127:96] = 32'h0;
        val[159:128]= 32'h0;
        val[162:160]= 3'b0;
        val[42] = 1'b1;
        val[101] = 1'b1;
        A = val;
        #1;

        check_outputs(1'b0);
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
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
