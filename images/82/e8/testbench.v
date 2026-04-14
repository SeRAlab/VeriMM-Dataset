`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg ABn;
    reg [1:0] B;
    wire [1:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ABn(ABn),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 2'b01;
        B = 2'b10;
        ABn = 1'b1;
        $display("Test %0d: Select A (ABn=1), A=2'b01, B=2'b10", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 2'b01;
        B = 2'b10;
        ABn = 1'b0;
        $display("Test %0d: Select B (ABn=0), A=2'b01, B=2'b10", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 2'b11;
        B = 2'b00;
        ABn = 1'b1;
        $display("Test %0d: Select A (ABn=1), A=2'b11, B=2'b00", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 2'b11;
        B = 2'b00;
        ABn = 1'b0;
        $display("Test %0d: Select B (ABn=0), A=2'b11, B=2'b00", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 2'b10;
        B = 2'b01;
        ABn = 1'b1;
        $display("Test %0d: Select A (ABn=1), A=2'b10, B=2'b01", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 2'b00;
        B = 2'b11;
        ABn = 1'b0;
        $display("Test %0d: Select B (ABn=0), A=2'b00, B=2'b11", test_num);
        #1;

        check_outputs(2'b11);
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
        input [1:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
