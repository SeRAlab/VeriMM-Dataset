`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] F;
    wire [31:0] Y;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .F(F),
        .Y(Y),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        F = 3'b000; A = 32'hAAAAAAAA; B = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hAAAAAAAA, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        F = 3'b001; A = 32'h55555555; B = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        F = 3'b010; A = 32'd100; B = 32'd250;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        F = 3'b100; A = 32'hFFFFFFFF; B = 32'h0000FFFF;
        #1;

        check_outputs(32'hFFFF0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        F = 3'b101; A = 32'd10; B = 32'd5;

        #1;


        check_outputs(32'h00000004, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        F = 3'b110; A = 32'd500; B = 32'd200;
        #1;

        check_outputs(32'd300, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        F = 3'b110; A = 32'h12345678; B = 32'h12345678;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        F = 3'b111; A = 32'd10; B = 32'd20;
        #1;

        check_outputs(32'h00000001, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        F = 3'b111; A = 32'd50; B = 32'd20;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        F = 3'b010; A = 32'hFFFFFFFF; B = 32'h00000001;
        #1;

        check_outputs(32'h00000000, 1'b1);
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
        input [31:0] expected_Y;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, Zero=%b",
                         Y, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, Zero=%b",
                         expected_Y, expected_Zero);
                $display("  Got:      Y=%h, Zero=%b",
                         Y, Zero);
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
