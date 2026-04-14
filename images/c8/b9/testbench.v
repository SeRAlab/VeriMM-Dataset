`timescale 1ns/1ps

module twos_complement_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    wire [15:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    twos_complement dut (
        .A(A),
        .B(B)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'h0000;
        $display("Test Case %0d: Input Zero (Positive path)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'h0005;
        $display("Test Case %0d: Input Small Positive (5)", test_num);
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'h7FFF;
        $display("Test Case %0d: Input Max Positive (32767)", test_num);
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'hFFFF;
        $display("Test Case %0d: Input Negative One (-1)", test_num);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'hFFFE;
        $display("Test Case %0d: Input Negative Two (-2)", test_num);
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'h8001;
        $display("Test Case %0d: Input -32767", test_num);
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'h8000;
        $display("Test Case %0d: Input Most Negative (-32768)", test_num);
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'hABCD;

        $display("Test Case %0d: Arbitrary Negative (0xABCD)", test_num);
        #1;

        check_outputs(16'h5433);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("twos_complement Testbench");
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
        input [15:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
