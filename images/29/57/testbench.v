`timescale 1ns/1ps

module sum_three_inputs_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] C;
    wire [5:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sum_three_inputs dut (
        .A(A),
        .B(B),
        .C(C),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=0, B=0, C=0", test_num);
        A = 5'd0;
        B = 5'd0;
        C = 5'd0;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=1, B=2, C=3", test_num);
        A = 5'd1;
        B = 5'd2;
        C = 5'd3;
        #1;

        check_outputs(6'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=10, B=15, C=5", test_num);
        A = 5'd10;
        B = 5'd15;
        C = 5'd5;
        #1;

        check_outputs(6'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=21, B=21, C=21", test_num);
        A = 5'd21;
        B = 5'd21;
        C = 5'd21;
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max inputs (31, 31, 31) checking 6-bit truncation", test_num);
        A = 5'd31;
        B = 5'd31;
        C = 5'd31;
        #1;

        check_outputs(6'd29);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=31, B=0, C=0", test_num);
        A = 5'd31;
        B = 5'd0;
        C = 5'd0;
        #1;

        check_outputs(6'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=16, B=8, C=4", test_num);
        A = 5'd16;
        B = 5'd8;
        C = 5'd4;
        #1;

        check_outputs(6'd28);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sum_three_inputs Testbench");
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
        input [5:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
