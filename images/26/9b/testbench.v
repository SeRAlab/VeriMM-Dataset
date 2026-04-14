`timescale 1ns/1ps

module brent_kung_adder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire C_OUT;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    brent_kung_adder dut (
        .A(A),
        .B(B),
        .C_OUT(C_OUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 5'd0;
        B = 5'd0;
        $display("Test Case %0d: Zero addition (0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 5'd15;
        B = 5'd1;
        $display("Test Case %0d: Carry propagation (15 + 1)", test_num);
        #1;

        check_outputs(1'b0, 5'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 5'd31;
        B = 5'd0;
        $display("Test Case %0d: Max A plus zero (31 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 5'd31;
        B = 5'd1;
        $display("Test Case %0d: Overflow/Carry Out (31 + 1)", test_num);
        #1;

        check_outputs(1'b1, 5'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 5'd31;
        B = 5'd31;
        $display("Test Case %0d: Max value addition (31 + 31)", test_num);
        #1;

        check_outputs(1'b1, 5'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 5'd10;
        B = 5'd20;
        $display("Test Case %0d: Generic addition (10 + 20)", test_num);
        #1;

        check_outputs(1'b0, 5'd30);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 5'b10101;
        B = 5'b01010;
        $display("Test Case %0d: Alternating bits (21 + 10)", test_num);
        #1;

        check_outputs(1'b0, 5'b11111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 5'd16;
        B = 5'd16;
        $display("Test Case %0d: Power of 2 carry (16 + 16)", test_num);
        #1;

        check_outputs(1'b1, 5'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 5'd7;
        B = 5'd8;
        $display("Test Case %0d: Small sum (7 + 8)", test_num);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 5'd25;
        B = 5'd10;
        $display("Test Case %0d: Sum with carry (25 + 10)", test_num);
        #1;

        check_outputs(1'b1, 5'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("brent_kung_adder Testbench");
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
        input expected_C_OUT;
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_OUT === (expected_C_OUT ^ C_OUT ^ expected_C_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: C_OUT=%b, SUM=%h",
                         C_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_OUT=%b, SUM=%h",
                         expected_C_OUT, expected_SUM);
                $display("  Got:      C_OUT=%b, SUM=%h",
                         C_OUT, SUM);
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
