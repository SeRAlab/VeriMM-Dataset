`timescale 1ns/1ps

module decoder_5_to_32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5_to_32 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input A = 0");
        A = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input A = 1");
        A = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input A = 2");
        A = 5'd2;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input A = 4");
        A = 5'd4;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input A = 8");
        A = 5'd8;
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input A = 15");
        A = 5'd15;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input A = 16");
        A = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input A = 23");
        A = 5'd23;
        #1;

        check_outputs(32'h00800000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input A = 30");
        A = 5'd30;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Input A = 31");
        A = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_5_to_32 Testbench");
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
