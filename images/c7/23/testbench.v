`timescale 1ns/1ps

module U2_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    U2 dut (
        .A(A),
        .B(B),
        .OUT(OUT)
    );
    task testcase001;

    begin
        A = 8'd100;
        B = 8'd40;
        test_num = test_num + 1;
        $display("Test Case %0d: A > B (100 - 40)", test_num);
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase002;

    begin
        A = 8'd30;
        B = 8'd80;
        test_num = test_num + 1;
        $display("Test Case %0d: A < B (80 - 30)", test_num);
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase003;

    begin
        A = 8'd255;
        B = 8'd255;
        test_num = test_num + 1;
        $display("Test Case %0d: A == B (Max values)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        A = 8'd0;
        B = 8'd0;
        test_num = test_num + 1;
        $display("Test Case %0d: A == B (Zero values)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        A = 8'd255;
        B = 8'd0;
        test_num = test_num + 1;
        $display("Test Case %0d: A is Max, B is Zero", test_num);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        A = 8'd0;
        B = 8'd255;
        test_num = test_num + 1;
        $display("Test Case %0d: A is Zero, B is Max", test_num);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase007;

    begin
        A = 8'd128;
        B = 8'd127;
        test_num = test_num + 1;
        $display("Test Case %0d: A = B + 1", test_num);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase008;

    begin
        A = 8'd127;
        B = 8'd128;
        test_num = test_num + 1;
        $display("Test Case %0d: B = A + 1", test_num);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase009;

    begin
        A = 8'hAA;
        B = 8'h55;
        test_num = test_num + 1;
        $display("Test Case %0d: Hex check (AA - 55)", test_num);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase010;

    begin
        A = 8'd1;
        B = 8'd2;
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum difference A < B", test_num);
        #1;

        check_outputs(8'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("U2 Testbench");
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
        input [7:0] expected_OUT;
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
