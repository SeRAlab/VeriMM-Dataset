`timescale 1ns/1ps

module wallace_tree_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [4:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wallace_tree_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs zero", test_num);
        A = 4'd0; B = 4'd0; C = 4'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Smallest non-zero sum", test_num);
        A = 4'd1; B = 4'd1; C = 4'd1;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single 4-bit max value", test_num);
        A = 4'd15; B = 4'd0; C = 4'd0;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum is power of 2 (16)", test_num);
        A = 4'd8; B = 4'd4; C = 4'd4;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed values", test_num);
        A = 4'd7; B = 4'd3; C = 4'd5;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 5-bit sum (31)", test_num);
        A = 4'd10; B = 4'd10; C = 4'd11;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max 4-bit inputs (checking 5-bit truncation)", test_num);
        A = 4'd15; B = 4'd15; C = 4'd15;
        #1;

        check_outputs(5'd13);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        A = 4'b1010;
        B = 4'b0101;
        C = 4'b1010;
        #1;

        check_outputs(5'd25);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry across stages", test_num);
        A = 4'd14; B = 4'd1; C = 4'd1;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum near 5-bit boundary", test_num);
        A = 4'd15; B = 4'd14; C = 4'd0;
        #1;

        check_outputs(5'd29);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wallace_tree_adder Testbench");
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
        input [4:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
