`timescale 1ns/1ps

module asr_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [4:0] shift_amount;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    asr_32bit dut (
        .A(A),
        .shift_amount(shift_amount),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'h12345678;
        shift_amount = 5'd0;
        $display("Test %0d: Identity - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'h00000010;
        shift_amount = 5'd4;
        $display("Test %0d: Positive Value Shift - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'h80000000;
        shift_amount = 5'd1;
        $display("Test %0d: Negative Value Sign Extension - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'hC0000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'h80000000;
        shift_amount = 5'd31;
        $display("Test %0d: Negative Value Max Shift - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'h7FFFFFFF;
        shift_amount = 5'd31;
        $display("Test %0d: Positive Value Max Shift - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'hDEADBEEF;
        shift_amount = 5'd8;
        $display("Test %0d: Negative Value Multi-nibble Shift - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'hFFDEADBE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'hFFFFFFFF;
        shift_amount = 5'd16;
        $display("Test %0d: All Ones Shift - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'h00000000;
        shift_amount = 5'd16;
        $display("Test %0d: All Zeros Shift - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 32'hAAAA_AAAA;
        shift_amount = 5'd2;
        $display("Test %0d: Alternating Bits Negative - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'hEAAA_AAAA);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 32'h5555_5555;
        shift_amount = 5'd2;
        $display("Test %0d: Alternating Bits Positive - A=%h, shift=%0d", test_num, A, shift_amount);
        #1;

        check_outputs(32'h1555_5555);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("asr_32bit Testbench");
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
