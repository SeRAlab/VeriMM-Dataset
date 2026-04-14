`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] C;
    reg CLK;
    reg [15:0] D;
    wire CO;
    wire [31:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CLK(CLK),
        .D(D),
        .CO(CO),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 0; B = 0; C = 0; D = 0;
        @(posedge CLK);
        #1;

        check_outputs(1'b0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        A = 0; B = 0; C = 0; D = 0;
        @(posedge CLK);

        A = 16'd10; D = 16'd2; B = 16'd5; C = 16'd1;
        @(posedge CLK);
        #1;

        check_outputs(1'b0, 32'd61);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 0; B = 0; C = 0; D = 0;
        @(posedge CLK);
        A = 16'h8000; D = 16'h8000; B = 16'h2; C = 16'h0;
        @(posedge CLK);
        #1;

        check_outputs(1'b0, 32'h00020000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 0; B = 0; C = 0; D = 0;
        @(posedge CLK);
        A = 16'hFFFF; D = 16'h0; B = 16'hFFFF; C = 16'h0;
        @(posedge CLK);
        #1;

        check_outputs(1'b0, 32'hFFFE0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 0; B = 0; C = 0; D = 0;
        @(posedge CLK);
        A = 16'hFFFF; D = 16'hFFFF; B = 16'hFFFF; C = 16'hFFFF;
        @(posedge CLK);
        #1;

        check_outputs(1'b1, 32'hFFFE0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 0; B = 0; C = 0; D = 0;
        @(posedge CLK);
        A = 0; D = 0; B = 0; C = 16'hABCD;
        @(posedge CLK);
        #1;

        check_outputs(1'b0, 32'h0000ABCD);
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
        input expected_CO;
        input [31:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, O=%h",
                         CO, O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, O=%h",
                         expected_CO, expected_O);
                $display("  Got:      CO=%b, O=%h",
                         CO, O);
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
