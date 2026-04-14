`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg ctrl;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Unsigned 0 * 0", test_num);
        A = 4'd0;
        B = 4'd0;
        ctrl = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Unsigned 15 * 15", test_num);
        A = 4'd15;
        B = 4'd15;
        ctrl = 1'b0;
        #1;

        check_outputs(8'hE1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Unsigned 7 * 13", test_num);
        A = 4'd7;
        B = 4'd13;
        ctrl = 1'b0;
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Signed 3 * 4", test_num);
        A = 4'sd3;
        B = 4'sd4;
        ctrl = 1'b1;
        #1;

        check_outputs(8'h0C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Signed 5 * -2", test_num);
        A = 4'sd5;
        B = -4'sd2;
        ctrl = 1'b1;
        #1;

        check_outputs(8'hF6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Signed -4 * 6", test_num);
        A = -4'sd4;
        B = 4'sd6;
        ctrl = 1'b1;
        #1;

        check_outputs(8'hE8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Signed -8 * -1", test_num);
        A = -4'sd8;
        B = -4'sd1;
        ctrl = 1'b1;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Signed -8 * -8", test_num);
        A = -4'sd8;
        B = -4'sd8;
        ctrl = 1'b1;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Signed -8 * 7", test_num);
        A = -4'sd8;
        B = 4'sd7;
        ctrl = 1'b1;
        #1;

        check_outputs(8'hC8);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Mode Switch (1111 * 0001)", test_num);


        A = 4'b1111;
        B = 4'b0001;
        ctrl = 1'b0;
        #1;

        check_outputs(8'h0F);


        test_num = test_num + 1;
        ctrl = 1'b1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
