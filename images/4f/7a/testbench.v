`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] kind;
    reg [31:0] valI;
    reg [31:0] valX;
    reg [31:0] valY;
    wire [31:0] valA;
    wire [31:0] valB;
    wire [31:0] valC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .kind(kind),
        .valI(valI),
        .valX(valX),
        .valY(valY),
        .valA(valA),
        .valB(valB),
        .valC(valC)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Kind 00 (valX, valY, valI)", test_num);
            kind = 2'b00;
            valX = 32'd100;
            valY = 32'd200;
            valI = 32'd300;
            #1;

            check_outputs(32'd100, 32'd200, 32'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Kind 01 (valX, valI, valY)", test_num);
            kind = 2'b01;
            valX = 32'd10;
            valY = 32'd20;
            valI = 32'd30;
            #1;

            check_outputs(32'd10, 32'd30, 32'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Kind 10 (valI, valX, valY)", test_num);
            kind = 2'b10;
            valX = -32'd50;
            valY = 32'd150;
            valI = 32'd250;
            #1;

            check_outputs(32'd250, -32'd50, 32'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Kind 11 (0, valX, valI)", test_num);
            kind = 2'b11;
            valX = 32'hAAAA_BBBB;
            valY = 32'hCCCC_DDDD;
            valI = 32'h1234_5678;
            #1;

            check_outputs(32'd0, 32'hAAAA_BBBB, 32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Signed Negative Values Kind 00", test_num);
            kind = 2'b00;
            valX = -32'sd1;
            valY = -32'sd2;
            valI = -32'sd3;
            #1;

            check_outputs(-32'sd1, -32'sd2, -32'sd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Signed Negative Values Kind 01", test_num);
            kind = 2'b01;
            valX = -32'sd1000;
            valY = -32'sd2000;
            valI = -32'sd3000;
            #1;

            check_outputs(-32'sd1000, -32'sd3000, -32'sd2000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Boundary Values (Max/Min Signed) Kind 10", test_num);
            kind = 2'b10;
            valX = 32'sh7FFFFFFF;
            valY = 32'sh80000000;
            valI = 32'sd0;
            #1;

            check_outputs(32'sd0, 32'sh7FFFFFFF, 32'sh80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Zero/Specific values Kind 11", test_num);
            kind = 2'b11;
            valX = 32'd0;
            valY = 32'd99999;
            valI = -32'sd1;
            #1;

            check_outputs(32'd0, 32'd0, -32'sd1);
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
        input [31:0] expected_valA;
        input [31:0] expected_valB;
        input [31:0] expected_valC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valA === (expected_valA ^ valA ^ expected_valA) &&
                expected_valB === (expected_valB ^ valB ^ expected_valB) &&
                expected_valC === (expected_valC ^ valC ^ expected_valC)) begin
                $display("PASS");
                $display("  Outputs: valA=%h, valB=%h, valC=%h",
                         valA, valB, valC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valA=%h, valB=%h, valC=%h",
                         expected_valA, expected_valB, expected_valC);
                $display("  Got:      valA=%h, valB=%h, valC=%h",
                         valA, valB, valC);
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
