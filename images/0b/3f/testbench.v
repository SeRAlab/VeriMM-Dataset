`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire Overflow;
    wire [31:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .A(A),
        .B(B),
        .Overflow(Overflow),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 32'd100;
        B = 32'd250;
        $display("Testcase %0d: Simple Addition (100 + 250)", test_num);
        #1;

        check_outputs(1'b0, 32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 32'hABCDE123;
        B = 32'd0;
        $display("Testcase %0d: Zero Addition", test_num);
        #1;

        check_outputs(1'b0, 32'hABCDE123);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        $display("Testcase %0d: Max value + 0", test_num);
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        $display("Testcase %0d: Overflow Boundary (FFFFFFFF + 1)", test_num);
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        $display("Testcase %0d: Max + Max", test_num);
        #1;

        check_outputs(1'b1, 32'hFFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        $display("Testcase %0d: Pattern Addition", test_num);
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 32'h80000000;
        B = 32'h80000001;
        $display("Testcase %0d: Large numbers overflow to 1", test_num);
        #1;

        check_outputs(1'b1, 32'h00000001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFE;
        B = 32'h00000002;
        $display("Testcase %0d: Carry propagation through all bits", test_num);
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 32'h12345678;
        B = 32'h11111111;
        $display("Testcase %0d: Random addition 1", test_num);
        #1;

        check_outputs(1'b0, 32'h23456789);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 32'hF0F0F0F0;
        B = 32'hF0F0F0F0;
        $display("Testcase %0d: Random addition 2 (overflow)", test_num);
        #1;

        check_outputs(1'b1, 32'hE1E1E1E0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input expected_Overflow;
        input [31:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Overflow=%b, Sum=%h",
                         Overflow, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Overflow=%b, Sum=%h",
                         expected_Overflow, expected_Sum);
                $display("  Got:      Overflow=%b, Sum=%h",
                         Overflow, Sum);
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
