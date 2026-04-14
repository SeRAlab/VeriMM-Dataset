`timescale 1ns/1ps

module SVM_tb;

    // Testbench signals (combinational circuit)
    reg B;
    reg [3:0] X1;
    reg [3:0] X2;
    wire decision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SVM dut (
        .B(B),
        .X1(X1),
        .X2(X2),
        .decision(decision)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimal inputs (X1=0, X2=0, B=0)", test_num);
        X1 = 4'd0;
        X2 = 4'd0;
        B  = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small positive result (X1=1, X2=1, B=0)", test_num);
        X1 = 4'd1;
        X2 = 4'd1;
        B  = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bias influence at zero boundary (X1=0, X2=0, B=1)", test_num);
        X1 = 4'd0;
        X2 = 4'd0;
        B  = 1'b1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: X2 outweighs X1 (X1=2, X2=5, B=0)", test_num);
        X1 = 4'd2;
        X2 = 4'd5;
        B  = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary condition Y=0 (X1=5, X2=10, B=0)", test_num);
        X1 = 4'd5;
        X2 = 4'd10;
        B  = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary condition shifted by bias (X1=5, X2=10, B=1)", test_num);
        X1 = 4'd5;
        X2 = 4'd10;
        B  = 1'b1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum X1 influence (X1=15, X2=0, B=0)", test_num);
        X1 = 4'd15;
        X2 = 4'd0;
        B  = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum X2 influence (X1=0, X2=15, B=0)", test_num);
        X1 = 4'd0;
        X2 = 4'd15;
        B  = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High values balancing out (X1=10, X2=15, B=0)", test_num);
        X1 = 4'd10;
        X2 = 4'd15;
        B  = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High values negative result (X1=4, X2=12, B=1)", test_num);
        X1 = 4'd4;
        X2 = 4'd12;
        B  = 1'b1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SVM Testbench");
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
        input expected_decision;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decision === (expected_decision ^ decision ^ expected_decision)) begin
                $display("PASS");
                $display("  Outputs: decision=%b",
                         decision);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decision=%b",
                         expected_decision);
                $display("  Got:      decision=%b",
                         decision);
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
