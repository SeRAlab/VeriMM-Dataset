`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] M;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .A(A),
        .B(B),
        .M(M)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0;
        B = 4'd0;
        $display("Testcase %0d: All Zeros (A=0, B=0)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd15;
        B = 4'd15;
        $display("Testcase %0d: Maximum Values (A=15, B=15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd10;
        B = 4'd2;
        $display("Testcase %0d: Even Sum (A=10, B=2)", test_num);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd15;
        B = 4'd0;
        $display("Testcase %0d: Truncation Check - Max/Zero (A=15, B=0)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd3;
        B = 4'd4;
        $display("Testcase %0d: Truncation Check - Small Odd (A=3, B=4)", test_num);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd0;
        B = 4'd15;
        $display("Testcase %0d: Input Symmetry (A=0, B=15)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd9;
        B = 4'd9;
        $display("Testcase %0d: Identical Inputs (A=9, B=9)", test_num);
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd14;
        B = 4'd15;
        $display("Testcase %0d: High Range Truncation (A=14, B=15)", test_num);
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd1;
        B = 4'd1;
        $display("Testcase %0d: Smallest Non-Zero (A=1, B=1)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'd5;
        B = 4'd10;
        $display("Testcase %0d: Typical Values (A=5, B=10)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
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
        input [3:0] expected_M;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M === (expected_M ^ M ^ expected_M)) begin
                $display("PASS");
                $display("  Outputs: M=%h",
                         M);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M=%h",
                         expected_M);
                $display("  Got:      M=%h",
                         M);
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
