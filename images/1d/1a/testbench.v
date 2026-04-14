`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [1:0] I;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .data_in(data_in),
        .I(I),
        .Q(Q)
    );
    task testcase001;

    begin
        data_in = 4'b0000;
        $display("Test Case 001: Input 0000 -> Expected (0, 0)");
        #1;

        check_outputs(VAL_0, VAL_0);
    end
        endtask

    task testcase002;

    begin
        data_in = 4'b0001;
        $display("Test Case 002: Input 0001 -> Expected (1, 0)");
        #1;

        check_outputs(VAL_1, VAL_0);
    end
        endtask

    task testcase003;

    begin
        data_in = 4'b0010;
        $display("Test Case 003: Input 0010 -> Expected (0, 1)");
        #1;

        check_outputs(VAL_0, VAL_1);
    end
        endtask

    task testcase004;

    begin
        data_in = 4'b0011;
        $display("Test Case 004: Input 0011 -> Expected (1, 1)");
        #1;

        check_outputs(VAL_1, VAL_1);
    end
        endtask

    task testcase005;

    begin
        data_in = 4'b0100;
        $display("Test Case 005: Input 0100 -> Expected (0, -1)");
        #1;

        check_outputs(VAL_0, VAL_N1);
    end
        endtask

    task testcase006;

    begin
        data_in = 4'b0101;
        $display("Test Case 006: Input 0101 -> Expected (1, -1)");
        #1;

        check_outputs(VAL_1, VAL_N1);
    end
        endtask

    task testcase007;

    begin
        data_in = 4'b0110;
        $display("Test Case 007: Input 0110 -> Expected (-1, 0)");
        #1;

        check_outputs(VAL_N1, VAL_0);
    end
        endtask

    task testcase008;

    begin
        data_in = 4'b0111;
        $display("Test Case 008: Input 0111 -> Expected (-1, 1)");
        #1;

        check_outputs(VAL_N1, VAL_1);
    end
        endtask

    task testcase009;

    begin
        data_in = 4'b1000;
        $display("Test Case 009: Input 1000 -> Expected (0, 0)");
        #1;

        check_outputs(VAL_0, VAL_0);
    end
        endtask

    task testcase010;

    begin
        data_in = 4'b1001;
        $display("Test Case 010: Input 1001 -> Expected (1, 0)");
        #1;

        check_outputs(VAL_1, VAL_0);
    end
        endtask

    task testcase011;

    begin
        data_in = 4'b1010;
        $display("Test Case 011: Input 1010 -> Expected (0, 1)");
        #1;

        check_outputs(VAL_0, VAL_1);
    end
        endtask

    task testcase012;

    begin
        data_in = 4'b1011;
        $display("Test Case 012: Input 1011 -> Expected (1, 1)");
        #1;

        check_outputs(VAL_1, VAL_1);
    end
        endtask

    task testcase013;

    begin
        data_in = 4'b1100;
        $display("Test Case 013: Input 1100 -> Expected (0, -1)");
        #1;

        check_outputs(VAL_0, VAL_N1);
    end
        endtask

    task testcase014;

    begin
        data_in = 4'b1101;
        $display("Test Case 014: Input 1101 -> Expected (1, -1)");
        #1;

        check_outputs(VAL_1, VAL_N1);
    end
        endtask

    task testcase015;

    begin
        data_in = 4'b1110;
        $display("Test Case 015: Input 1110 -> Expected (-1, 0)");
        #1;

        check_outputs(VAL_N1, VAL_0);
    end
        endtask

    task testcase016;

    begin
        data_in = 4'b1111;
        $display("Test Case 016: Input 1111 -> Expected (-1, 1)");
        #1;

        check_outputs(VAL_N1, VAL_1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [1:0] expected_I;
        input [1:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I === (expected_I ^ I ^ expected_I) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: I=%h, Q=%h",
                         I, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%h, Q=%h",
                         expected_I, expected_Q);
                $display("  Got:      I=%h, Q=%h",
                         I, Q);
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
