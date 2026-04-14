`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg x;
    reg y;
    wire A;
    wire B;
    wire C;
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
        .B(B),
        .C(C),
        .cout(cout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: x=0, y=0, cin=0");
            x = 1'b0; y = 1'b0; cin = 1'b0;




            #1;





            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: x=0, y=1 (y is -1), cin=0");
            x = 1'b0; y = 1'b1; cin = 1'b0;




            #1;





            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: x=1, y=0, cin=0");
            x = 1'b1; y = 1'b0; cin = 1'b0;




            #1;





            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: x=1 (x is -1), y=1 (y is -1), cin=0");
            x = 1'b1; y = 1'b1; cin = 1'b0;




            #1;





            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Verify cin is ignored in No-BUG mode");
            x = 1'b0; y = 1'b1; cin = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: x=0, y=0, cin=1");
            x = 1'b0; y = 1'b0; cin = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_A;
        input expected_B;
        input expected_C;
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: A=%b, B=%b, C=%b, cout=%b",
                         A, B, C, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, B=%b, C=%b, cout=%b",
                         expected_A, expected_B, expected_C, expected_cout);
                $display("  Got:      A=%b, B=%b, C=%b, cout=%b",
                         A, B, C, cout);
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
