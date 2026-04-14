`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire OVF;
    wire [1:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OVF(OVF),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=0, B=0 (No Overflow)", test_num);
        A = 2'b00; B = 2'b00;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=1, B=1 (No Overflow)", test_num);
        A = 2'b01; B = 2'b01;
        #1;

        check_outputs(1'b0, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=1, B=2 (Boundary - Max Sum No Overflow)", test_num);
        A = 2'b01; B = 2'b10;
        #1;

        check_outputs(1'b0, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=3, B=0 (Boundary - Max Sum No Overflow)", test_num);
        A = 2'b11; B = 2'b00;
        #1;

        check_outputs(1'b0, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=2, B=2 (Overflow - Sum is 4)", test_num);
        A = 2'b10; B = 2'b10;

        #1;


        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=3, B=1 (Overflow - Sum is 4)", test_num);
        A = 2'b11; B = 2'b01;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=3, B=2 (Overflow - Sum is 5)", test_num);
        A = 2'b11; B = 2'b10;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inputs A=3, B=3 (Maximum Overflow - Sum is 6)", test_num);
        A = 2'b11; B = 2'b11;
        #1;

        check_outputs(1'b1, 2'b11);
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
        input expected_OVF;
        input [1:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OVF === (expected_OVF ^ OVF ^ expected_OVF) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: OVF=%b, Z=%h",
                         OVF, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVF=%b, Z=%h",
                         expected_OVF, expected_Z);
                $display("  Got:      OVF=%b, Z=%h",
                         OVF, Z);
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
