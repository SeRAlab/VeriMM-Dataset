`timescale 1ns/1ps

module alu_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0] Ctrl;
    wire [15:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_16bit dut (
        .A(A),
        .B(B),
        .Ctrl(Ctrl),
        .Result(Result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (00) - Basic positive numbers", test_num);
        A = 16'h0010;
        B = 16'h0020;
        Ctrl = 2'b00;
        #1;

        check_outputs(16'h0030);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition (00) - Max value wrap-around", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        Ctrl = 2'b00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Subtraction (01) - Basic positive result", test_num);
        A = 16'h0050;
        B = 16'h0010;
        Ctrl = 2'b01;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction (01) - Result wrapping (negative)", test_num);
        A = 16'h0005;
        B = 16'h000A;
        Ctrl = 2'b01;
        #1;

        check_outputs(16'hFFFB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bitwise AND (10) - Masking operation", test_num);
        A = 16'hAAAA;
        B = 16'hF0F0;
        Ctrl = 2'b10;
        #1;

        check_outputs(16'hA0A0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bitwise AND (10) - No matching bits", test_num);
        A = 16'h1234;
        B = 16'hEDCB;
        Ctrl = 2'b10;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Addition (00) - Zero identity", test_num);
        A = 16'hABCD;
        B = 16'h0000;
        Ctrl = 2'b00;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Subtraction (01) - Identity subtraction", test_num);
        A = 16'h1234;
        B = 16'h1234;
        Ctrl = 2'b01;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_16bit Testbench");
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
        input [15:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
