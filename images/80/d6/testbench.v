`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ABn;
    reg [15:0] Ax;
    reg [15:0] Ay;
    reg [15:0] Az;
    reg [15:0] Bx;
    reg [15:0] By;
    reg [15:0] Bz;
    wire [15:0] Cx;
    wire [15:0] Cy;
    wire [15:0] Cz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABn(ABn),
        .Ax(Ax),
        .Ay(Ay),
        .Az(Az),
        .Bx(Bx),
        .By(By),
        .Bz(Bz),
        .Cx(Cx),
        .Cy(Cy),
        .Cz(Cz)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Set A (ABn=1) with standard hex values", test_num);
        ABn = 1'b1;
        Ax = 16'hAAAA; Ay = 16'hBBBB; Az = 16'hCCCC;
        Bx = 16'h1111; By = 16'h2222; Bz = 16'h3333;
        #1;

        check_outputs(16'hAAAA, 16'hBBBB, 16'hCCCC);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Set B (ABn=0) with standard hex values", test_num);
        ABn = 1'b0;
        Ax = 16'hAAAA; Ay = 16'hBBBB; Az = 16'hCCCC;
        Bx = 16'h1111; By = 16'h2222; Bz = 16'h3333;
        #1;

        check_outputs(16'h1111, 16'h2222, 16'h3333);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Set A (ABn=1) with All Zeros and All Fs", test_num);
        ABn = 1'b1;
        Ax = 16'h0000; Ay = 16'h0000; Az = 16'h0000;
        Bx = 16'hFFFF; By = 16'hFFFF; Bz = 16'hFFFF;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Set B (ABn=0) with All Zeros and All Fs", test_num);
        ABn = 1'b0;
        Ax = 16'h0000; Ay = 16'h0000; Az = 16'h0000;
        Bx = 16'hFFFF; By = 16'hFFFF; Bz = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching ABn dynamically while inputs are constant (Set A)", test_num);
        Ax = 16'h1234; Ay = 16'h5678; Az = 16'h9ABC;
        Bx = 16'hFEDC; By = 16'hBA98; Bz = 16'h7654;
        ABn = 1'b1;
        #1;

        check_outputs(16'h1234, 16'h5678, 16'h9ABC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching ABn dynamically while inputs are constant (Set B)", test_num);
        Ax = 16'h1234; Ay = 16'h5678; Az = 16'h9ABC;
        Bx = 16'hFEDC; By = 16'hBA98; Bz = 16'h7654;
        ABn = 1'b0;
        #1;

        check_outputs(16'hFEDC, 16'hBA98, 16'h7654);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking bit pattern on Set A (ABn=1)", test_num);
        ABn = 1'b1;
        Ax = 16'h0001; Ay = 16'h0002; Az = 16'h0004;
        Bx = 16'h8000; By = 16'h4000; Bz = 16'h2000;
        #1;

        check_outputs(16'h0001, 16'h0002, 16'h0004);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bit pattern on Set B (ABn=0)", test_num);
        ABn = 1'b0;
        Ax = 16'h5555; Ay = 16'h5555; Az = 16'h5555;
        Bx = 16'hAAAA; By = 16'hAAAA; Bz = 16'hAAAA;
        #1;

        check_outputs(16'hAAAA, 16'hAAAA, 16'hAAAA);
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
        input [15:0] expected_Cx;
        input [15:0] expected_Cy;
        input [15:0] expected_Cz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cx === (expected_Cx ^ Cx ^ expected_Cx) &&
                expected_Cy === (expected_Cy ^ Cy ^ expected_Cy) &&
                expected_Cz === (expected_Cz ^ Cz ^ expected_Cz)) begin
                $display("PASS");
                $display("  Outputs: Cx=%h, Cy=%h, Cz=%h",
                         Cx, Cy, Cz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cx=%h, Cy=%h, Cz=%h",
                         expected_Cx, expected_Cy, expected_Cz);
                $display("  Got:      Cx=%h, Cy=%h, Cz=%h",
                         Cx, Cy, Cz);
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
