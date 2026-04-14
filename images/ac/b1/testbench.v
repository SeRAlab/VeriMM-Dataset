`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'sd0; B = 8'sd0;
        $display("Test %0d: A=%0d, B=%0d (Zero case)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'sd1; B = 8'sd1;
        $display("Test %0d: A=%0d, B=%0d (Small positive)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'sd10; B = 8'sd12;
        $display("Test %0d: A=%0d, B=%0d (Positive multiplication)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd120);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'sd127; B = 8'sd1;
        $display("Test %0d: A=%0d, B=%0d (Max positive boundary)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd127);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'sd127; B = 8'sd127;
        $display("Test %0d: A=%0d, B=%0d (Max positive squared)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd16129);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = -8'sd1; B = 8'sd1;
        $display("Test %0d: A=%0d, B=%0d (Negative * Positive)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(-16'sd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'sd5; B = -8'sd10;
        $display("Test %0d: A=%0d, B=%0d (Positive * Negative)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(-16'sd50);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = -8'sd12; B = -8'sd10;
        $display("Test %0d: A=%0d, B=%0d (Negative * Negative)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd120);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = -8'sd128; B = 8'sd127;
        $display("Test %0d: A=%0d, B=%0d (Min negative * Max positive)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(-16'sd16256);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = -8'sd128; B = -8'sd128;
        $display("Test %0d: A=%0d, B=%0d (Min negative squared)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd16384);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 8'sd0; B = -8'sd128;
        $display("Test %0d: A=%0d, B=%0d (Zero * Min negative)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = -8'sd1; B = -8'sd1;
        $display("Test %0d: A=%0d, B=%0d (-1 squared)", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(16'sd1);
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
        testcase011();
        testcase012();
        
        
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
        input [15:0] expected_C;
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
