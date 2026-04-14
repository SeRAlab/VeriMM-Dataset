`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [1:0] I_out;
    wire [1:0] Q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .data_in(data_in),
        .I_out(I_out),
        .Q_out(Q_out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Data In 4'b0000");
        test_num = 1;
        data_in = 4'b0000;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Data In 4'b0001");
        test_num = 2;
        data_in = 4'b0001;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Data In 4'b0010");
        test_num = 3;
        data_in = 4'b0010;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Data In 4'b0011");
        test_num = 4;
        data_in = 4'b0011;
        #1;

        check_outputs(2'b00, 2'b11);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Data In 4'b0100");
        test_num = 5;
        data_in = 4'b0100;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Data In 4'b0101");
        test_num = 6;
        data_in = 4'b0101;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Data In 4'b0110");
        test_num = 7;
        data_in = 4'b0110;
        #1;

        check_outputs(2'b01, 2'b10);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Data In 4'b0111");
        test_num = 8;
        data_in = 4'b0111;
        #1;

        check_outputs(2'b01, 2'b11);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Data In 4'b1000");
        test_num = 9;
        data_in = 4'b1000;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: Data In 4'b1001");
        test_num = 10;
        data_in = 4'b1001;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: Data In 4'b1010");
        test_num = 11;
        data_in = 4'b1010;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: Data In 4'b1011");
        test_num = 12;
        data_in = 4'b1011;
        #1;

        check_outputs(2'b10, 2'b11);
    end
        endtask

    task testcase013;

    begin
        $display("Test Case 013: Data In 4'b1100");
        test_num = 13;
        data_in = 4'b1100;
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase014;

    begin
        $display("Test Case 014: Data In 4'b1101");
        test_num = 14;
        data_in = 4'b1101;
        #1;

        check_outputs(2'b11, 2'b01);
    end
        endtask

    task testcase015;

    begin
        $display("Test Case 015: Data In 4'b1110");
        test_num = 15;
        data_in = 4'b1110;
        #1;

        check_outputs(2'b11, 2'b10);
    end
        endtask

    task testcase016;

    begin
        $display("Test Case 016: Data In 4'b1111");
        test_num = 16;
        data_in = 4'b1111;
        #1;

        check_outputs(2'b11, 2'b11);
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
        input [1:0] expected_I_out;
        input [1:0] expected_Q_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I_out === (expected_I_out ^ I_out ^ expected_I_out) &&
                expected_Q_out === (expected_Q_out ^ Q_out ^ expected_Q_out)) begin
                $display("PASS");
                $display("  Outputs: I_out=%h, Q_out=%h",
                         I_out, Q_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I_out=%h, Q_out=%h",
                         expected_I_out, expected_Q_out);
                $display("  Got:      I_out=%h, Q_out=%h",
                         I_out, Q_out);
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
