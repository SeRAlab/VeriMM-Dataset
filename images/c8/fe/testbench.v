`timescale 1ns/1ps

module compare_and_operate_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    compare_and_operate dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A < B (A=4'd2, B=4'd8)", test_num);
        A = 4'd2;
        B = 4'd8;

        #1;


        check_outputs(5'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A > B (A=4'd12, B=4'd4)", test_num);
        A = 4'd12;
        B = 4'd4;

        #1;


        check_outputs(5'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A == B (A=4'd9, B=4'd9)", test_num);
        A = 4'd9;
        B = 4'd9;

        #1;


        check_outputs(5'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A < B (A=4'd14, B=4'd15)", test_num);
        A = 4'd14;
        B = 4'd15;

        #1;


        check_outputs(5'd29);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A > B (A=4'd15, B=4'd0)", test_num);
        A = 4'd15;
        B = 4'd0;

        #1;


        check_outputs(5'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A == B (A=4'd0, B=4'd0)", test_num);
        A = 4'd0;
        B = 4'd0;

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A == B (A=4'd15, B=4'd15)", test_num);
        A = 4'd15;
        B = 4'd15;

        #1;


        check_outputs(5'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A < B (A=4'd0, B=4'd1)", test_num);
        A = 4'd0;
        B = 4'd1;

        #1;


        check_outputs(5'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("compare_and_operate Testbench");
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
        input [4:0] expected_C;
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
