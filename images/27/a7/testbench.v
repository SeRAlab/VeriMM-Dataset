`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire CO;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .A(A),
        .B(B),
        .CO(CO),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Addition (1 + 1)", test_num);
        A = 32'h00000001;
        B = 32'h00000001;
        #1;

        check_outputs(1'b0, 32'h00000002);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        #1;

        check_outputs(1'b0, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max result without CO (FFFF FFFE + 1)", test_num);
        A = 32'hFFFFFFFE;
        B = 32'h00000001;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry Out Generation (FFFF FFFF + 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max values addition (FFFF FFFF + FFFF FFFF)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b1, 32'hFFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (5555... + AAAA...)", test_num);
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry from middle (7FFF FFFF + 1)", test_num);
        A = 32'h7FFFFFFF;
        B = 32'h00000001;
        #1;

        check_outputs(1'b0, 32'h80000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry with high bit (8000 0000 + 8000 0000)", test_num);
        A = 32'h80000000;
        B = 32'h80000000;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Patterned addition", test_num);
        A = 32'h12345678;
        B = 32'h11111111;
        #1;

        check_outputs(1'b0, 32'h23456789);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry to last bit (F000 0000 + 1000 0000)", test_num);
        A = 32'hF0000000;
        B = 32'h10000000;
        #1;

        check_outputs(1'b1, 32'h00000000);
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
        input expected_CO;
        input [31:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, S=%h",
                         CO, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, S=%h",
                         expected_CO, expected_S);
                $display("  Got:      CO=%b, S=%h",
                         CO, S);
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
