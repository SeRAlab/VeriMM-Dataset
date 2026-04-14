`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [4:0] i0;
    reg [4:0] i1;
    wire cout;
    wire [4:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .i0(i0),
        .i1(i1),
        .cout(cout),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0, cin=0", test_num);
            i0 = 5'd0;
            i1 = 5'd0;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0, cin=1", test_num);
            i0 = 5'd0;
            i1 = 5'd0;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 5'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 31 + 0, cin=0", test_num);
            i0 = 5'd31;
            i1 = 5'd0;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 31 + 1, cin=0", test_num);
            i0 = 5'd31;
            i1 = 5'd1;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 31 + 31, cin=1", test_num);
            i0 = 5'd31;
            i1 = 5'd31;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 15 + 16, cin=0", test_num);
            i0 = 5'd15;
            i1 = 5'd16;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 16 + 16, cin=0", test_num);
            i0 = 5'd16;
            i1 = 5'd16;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10 + 5, cin=1", test_num);
            i0 = 5'd10;
            i1 = 5'd5;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 5'd16);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10 (10101) + 21 (01010), cin=0", test_num);
            i0 = 5'b01010;
            i1 = 5'b10101;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 5'b11111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 15 + 1, cin=0 (Ripple check)", test_num);
            i0 = 5'b01111;
            i1 = 5'b00001;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 5'b10000);
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
        input expected_cout;
        input [4:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, s=%h",
                         cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, s=%h",
                         expected_cout, expected_s);
                $display("  Got:      cout=%b, s=%h",
                         cout, s);
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
