`timescale 1ns/1ps

module carry_skip_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Cin;
    wire Cout;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_skip_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Addition (0 + 0 + 0)", test_num);
        A = 8'h00;
        B = 8'h00;
        Cin = 0;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Addition (0x12 + 0x34)", test_num);
        A = 8'h12;
        B = 8'h34;
        Cin = 0;
        #1;

        check_outputs(1'b0, 8'h46);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with Cin (0x05 + 0x02 + 1)", test_num);
        A = 8'h05;
        B = 8'h02;
        Cin = 1;
        #1;

        check_outputs(1'b0, 8'h08);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Carry (0x0F + 0x01)", test_num);
        A = 8'h0F;
        B = 8'h01;
        Cin = 0;
        #1;

        check_outputs(1'b0, 8'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Skip Logic Trigger Block 0 (A^B=0x0F, Cin=1)", test_num);
        A = 8'h0A;
        B = 8'h05;
        Cin = 1;

        #1;


        check_outputs(1'b0, 8'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full 8-bit Skip (A^B=0xFF, Cin=1)", test_num);
        A = 8'hAA;
        B = 8'h55;
        Cin = 1;

        #1;


        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Values (0xFF + 0xFF + 1)", test_num);
        A = 8'hFF;
        B = 8'hFF;
        Cin = 1;

        #1;


        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High Nibble Carry Out (0xF0 + 0x10)", test_num);
        A = 8'hF0;
        B = 8'h10;
        Cin = 0;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed Pattern (0xA5 + 0x5A)", test_num);
        A = 8'hA5;
        B = 8'h5A;
        Cin = 0;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large Addition (0x80 + 0x80)", test_num);
        A = 8'h80;
        B = 8'h80;
        Cin = 0;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_skip_adder Testbench");
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
        input expected_Cout;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
