`timescale 1ns/1ps

module add_with_enable_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg enable;
    wire C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_with_enable dut (
        .A(A),
        .B(B),
        .enable(enable),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Enable High - Simple Addition (0+0)", test_num);

        enable = 1; A = 0; B = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Enable High - Simple Addition (1+0)", test_num);

        enable = 1; A = 0; B = 0; #5;

        A = 1; B = 0;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Enable High - Simple Addition (1+1)", test_num);

        enable = 1; A = 0; B = 0; #5;

        A = 1; B = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Enable Low - Hold Previous Value (0)", test_num);

        enable = 1; A = 0; B = 0; #5;

        enable = 0;
        #5;
        A = 1; B = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Enable Low - Hold Previous Value (1)", test_num);

        enable = 1; A = 1; B = 0; #5;

        enable = 0;
        #5;
        A = 1; B = 1;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Toggle Enable - Update Held Value", test_num);

        enable = 1; A = 0; B = 0; #5;

        enable = 0; A = 1; B = 1; #5;

        enable = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_with_enable Testbench");
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
        input expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%b",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b",
                         expected_C);
                $display("  Got:      C=%b",
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
