`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLR;
    reg EN;
    wire COUT;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLR(CLR),
        .EN(EN),
        .COUT(COUT),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asserting CLR - Output should be zero", test_num);

        CLR = 1;
        EN = 1;
        A = 8'hFF;
        B = 8'hFF;
        #10;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: EN=1, CLR=0 - Simple addition without carry", test_num);

        CLR = 1; #5;
        CLR = 0;
        EN = 1;
        A = 8'h05;
        B = 8'h10;
        #10;

        #1;


        check_outputs(1'b0, 8'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: EN=1, CLR=0 - Addition with carry-out", test_num);

        CLR = 1; #5;
        CLR = 0;
        EN = 1;
        A = 8'h80;
        B = 8'h80;
        #10;

        #1;


        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: EN=1, CLR=0 - Maximum values (255+255)", test_num);

        CLR = 1; #5;
        CLR = 0;
        EN = 1;
        A = 8'hFF;
        B = 8'hFF;
        #10;

        #1;


        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: EN=0, CLR=0 - Disabled state", test_num);

        CLR = 1; #5;
        CLR = 0;
        EN = 0;
        A = 8'h12;
        B = 8'h34;
        #10;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority check - CLR over EN and inputs", test_num);

        CLR = 1;
        EN = 1;
        A = 8'hAA;
        B = 8'h55;
        #10;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary check - Result is exactly 255", test_num);

        CLR = 1; #5;
        CLR = 0;
        EN = 1;
        A = 8'hF0;
        B = 8'h0F;
        #10;

        #1;


        check_outputs(1'b0, 8'hFF);
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
        input expected_COUT;
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, S=%h",
                         COUT, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, S=%h",
                         expected_COUT, expected_S);
                $display("  Got:      COUT=%b, S=%h",
                         COUT, S);
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
