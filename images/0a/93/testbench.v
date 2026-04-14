`timescale 1ns/1ps

module two_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire Carry;
    wire [1:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    two_bit_adder dut (
        .A(A),
        .B(B),
        .Carry(Carry),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 2'b00; B = 2'b00;
        $display("Test %03d: A=0, B=0", test_num);
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 2'b01; B = 2'b00;
        $display("Test %03d: A=1, B=0", test_num);
        #1;

        check_outputs(1'b0, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 2'b01; B = 2'b01;
        $display("Test %03d: A=1, B=1", test_num);
        #1;

        check_outputs(1'b0, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 2'b10; B = 2'b01;
        $display("Test %03d: A=2, B=1", test_num);
        #1;

        check_outputs(1'b0, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 2'b10; B = 2'b10;
        $display("Test %03d: A=2, B=2", test_num);
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 2'b11; B = 2'b01;
        $display("Test %03d: A=3, B=1", test_num);
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 2'b11; B = 2'b10;
        $display("Test %03d: A=3, B=2", test_num);
        #1;

        check_outputs(1'b1, 2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 2'b11; B = 2'b11;
        $display("Test %03d: A=3, B=3", test_num);
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("two_bit_adder Testbench");
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
        input expected_Carry;
        input [1:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Carry=%b, Sum=%h",
                         Carry, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%b, Sum=%h",
                         expected_Carry, expected_Sum);
                $display("  Got:      Carry=%b, Sum=%h",
                         Carry, Sum);
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
