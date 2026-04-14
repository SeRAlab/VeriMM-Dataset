`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [3:0] I_out;
    wire [3:0] Q_out;

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
        test_num = 1;
        $display("Test Case 001: data_in = 0000");
        data_in = 4'b0000;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: data_in = 0001");
        data_in = 4'b0001;
        #1;

        check_outputs(4'h0, 4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: data_in = 0010");
        data_in = 4'b0010;
        #1;

        check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: data_in = 0011");
        data_in = 4'b0011;
        #1;

        check_outputs(4'h1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: data_in = 0100");
        data_in = 4'b0100;
        #1;

        check_outputs(4'h1, 4'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: data_in = 0101");
        data_in = 4'b0101;
        #1;

        check_outputs(4'h1, 4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: data_in = 0110");
        data_in = 4'b0110;
        #1;

        check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: data_in = 0111");
        data_in = 4'b0111;
        #1;

        check_outputs(4'hF, 4'h1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: data_in = 1000");
        data_in = 4'b1000;
        #1;

        check_outputs(4'hF, 4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: data_in = 1001");
        data_in = 4'b1001;
        #1;

        check_outputs(4'h0, 4'h2);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 011: data_in = 1010");
        data_in = 4'b1010;
        #1;

        check_outputs(4'h0, 4'hE);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 012: data_in = 1011");
        data_in = 4'b1011;
        #1;

        check_outputs(4'h2, 4'h0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case 013: data_in = 1100");
        data_in = 4'b1100;
        #1;

        check_outputs(4'h2, 4'h1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case 014: data_in = 1101");
        data_in = 4'b1101;
        #1;

        check_outputs(4'h2, 4'hF);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case 015: data_in = 1110");
        data_in = 4'b1110;
        #1;

        check_outputs(4'hE, 4'h0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case 016: data_in = 1111");
        data_in = 4'b1111;
        #1;

        check_outputs(4'hE, 4'h1);
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
        input [3:0] expected_I_out;
        input [3:0] expected_Q_out;
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
