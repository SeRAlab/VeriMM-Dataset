`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] cin;
    reg x;
    reg [2:0] y;
    wire A;
    wire control;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .x(x),
        .y(y),
        .A(A),
        .control(control),
        .cout(cout)
    );
    task calculate_expected;

        begin

            exp_A = (^ (~y)) ^ (& (~cin));



            exp_control = x ? (&y) : (|cin);
            exp_cout = (x & (|y)) | (&cin);
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        x = 0; y = 3'b000; cin = 3'b000;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 1; y = 3'b000; cin = 3'b000;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 0; y = 3'b111; cin = 3'b000;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 0; y = 3'b000; cin = 3'b111;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 1; y = 3'b101; cin = 3'b010;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 0; y = 3'b011; cin = 3'b100;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 1; y = 3'b010; cin = 3'b101;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 1; y = 3'b111; cin = 3'b111;
        calculate_expected();
        #1;

        check_outputs(exp_A, exp_control, exp_cout);
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
        input expected_A;
        input expected_control;
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_control === (expected_control ^ control ^ expected_control) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: A=%b, control=%b, cout=%b",
                         A, control, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, control=%b, cout=%b",
                         expected_A, expected_control, expected_cout);
                $display("  Got:      A=%b, control=%b, cout=%b",
                         A, control, cout);
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
