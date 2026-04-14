`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg ADD;
    reg [3:0] B;
    reg SEL;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ADD(ADD),
        .B(B),
        .SEL(SEL),
        .OUT(OUT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'h5; B = 4'hA; SEL = 0; ADD = 0;
        $display("Test %0d: SEL=0, ADD=0 (Select A) - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'hF; B = 4'h1; SEL = 0; ADD = 1;
        $display("Test %0d: SEL=0, ADD=1 (Select A) - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'h2; B = 4'hC; SEL = 1; ADD = 0;
        $display("Test %0d: SEL=1, ADD=0 (Select B) - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'h3; B = 4'h4; SEL = 1; ADD = 1;
        $display("Test %0d: SEL=1, ADD=1 (Sum A+B) - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'hE; B = 4'h3; SEL = 1; ADD = 1;
        $display("Test %0d: SEL=1, ADD=1 (Sum A+B with Overflow) - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'hF; B = 4'hF; SEL = 1; ADD = 1;
        $display("Test %0d: SEL=1, ADD=1 (Sum A+B max values) - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'h0; B = 4'h0; SEL = 1; ADD = 0;
        $display("Test %0d: SEL=1, ADD=0 (Select B zeros) - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
