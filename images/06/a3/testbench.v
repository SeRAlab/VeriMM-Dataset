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
        test_num = test_num + 1;
        $display("Test %0d: Both inputs zero", test_num);
        A = 4'd0;
        B = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both inputs maximum", test_num);
        A = 4'd15;
        B = 4'd15;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identical mid-range inputs", test_num);
        A = 4'd8;
        B = 4'd8;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Even sum averaging", test_num);
        A = 4'd10;
        B = 4'd4;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Odd sum averaging (truncation check)", test_num);
        A = 4'd5;
        B = 4'd4;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: One zero, one max (truncation check)", test_num);
        A = 4'd0;
        B = 4'd15;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: One and two", test_num);
        A = 4'd1;
        B = 4'd2;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Values with high bit difference", test_num);
        A = 4'd14;
        B = 4'd2;
        #1;

        check_outputs(4'd8);
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
