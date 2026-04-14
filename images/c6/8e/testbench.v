`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] C;
    wire Cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .C(C),
        .Cout(Cout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros (0 + 0 + 0)", test_num);
        A = 4'b0000; B = 4'b0000; Cin = 1'b0;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition without carry (5 + 3 + 0)", test_num);
        A = 4'd5; B = 4'd3; Cin = 1'b0;
        #1;

        check_outputs(4'd8, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition with Cin (5 + 3 + 1)", test_num);
        A = 4'd5; B = 4'd3; Cin = 1'b1;
        #1;

        check_outputs(4'd9, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition resulting in Max 4-bit value (10 + 5 + 0)", test_num);
        A = 4'd10; B = 4'd5; Cin = 1'b0;
        #1;

        check_outputs(4'd15, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow condition (8 + 8 + 0)", test_num);
        A = 4'd8; B = 4'd8; Cin = 1'b0;
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow condition with Cin (15 + 0 + 1)", test_num);
        A = 4'd15; B = 4'd0; Cin = 1'b1;
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large addition with carry (12 + 7 + 0)", test_num);
        A = 4'd12; B = 4'd7; Cin = 1'b0;
        #1;

        check_outputs(4'd3, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum possible addition (15 + 15 + 1)", test_num);
        A = 4'd15; B = 4'd15; Cin = 1'b1;
        #1;

        check_outputs(4'd15, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero addition with Cin (0 + 0 + 1)", test_num);
        A = 4'd0; B = 4'd0; Cin = 1'b1;
        #1;

        check_outputs(4'd1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits (10 + 5 + 1)", test_num);
        A = 4'b1010; B = 4'b0101; Cin = 1'b1;
        #1;

        check_outputs(4'b0000, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input [3:0] expected_C;
        input expected_Cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Cout === (expected_Cout ^ Cout ^ expected_Cout)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Cout=%b",
                         C, Cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Cout=%b",
                         expected_C, expected_Cout);
                $display("  Got:      C=%h, Cout=%b",
                         C, Cout);
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
