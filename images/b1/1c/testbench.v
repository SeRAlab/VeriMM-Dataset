`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [31:0] D;
    reg [1:0] sel;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input A", test_num);
        A = 32'h12345678;
        B = 32'h00000000;
        C = 32'hFFFFFFFF;
        D = 32'hAAAAAAAA;
        sel = 2'b00;
        #10;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input B", test_num);
        A = 32'h12345678;
        B = 32'h87654321;
        C = 32'h00000000;
        D = 32'h55555555;
        sel = 2'b01;
        #10;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input C", test_num);
        A = 32'h00000000;
        B = 32'hFFFFFFFF;
        C = 32'hDEADBEEF;
        D = 32'hCAFEBABE;
        sel = 2'b10;
        #10;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input D", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        C = 32'h00000000;
        D = 32'hFEEDFACE;
        sel = 2'b11;
        #10;
        #1;

        check_outputs(32'hFEEDFACE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verification of All Bits (All Ones)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        C = 32'h00000000;
        D = 32'h00000000;
        sel = 2'b00;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input Independence (Changing A while B is selected)", test_num);
        A = 32'h11111111;
        B = 32'h22222222;
        C = 32'h33333333;
        D = 32'h44444444;
        sel = 2'b01;
        #5;
        A = 32'h99999999;
        #5;
        #1;

        check_outputs(32'h22222222);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Values Test", test_num);
        A = 32'h0; B = 32'h0; C = 32'h0; D = 32'h0;
        sel = 2'b10;
        #10;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MSB and LSB toggle", test_num);
        A = 32'h0; B = 32'h0; C = 32'h0;
        D = 32'h80000001;
        sel = 2'b11;
        #10;
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
