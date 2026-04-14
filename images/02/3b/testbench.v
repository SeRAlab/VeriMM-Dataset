`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [3:0] I;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .data(data),
        .I(I),
        .Q(Q)
    );
    task testcase001;

    begin
        data = 4'b0000;
        $display("Test Case 001: Input data=0000");
        #1;

        check_outputs(4'h1, 4'h1);
    end
        endtask

    task testcase002;

    begin
        data = 4'b0001;
        $display("Test Case 002: Input data=0001");
        #1;

        check_outputs(4'h1, 4'h3);
    end
        endtask

    task testcase003;

    begin
        data = 4'b0010;
        $display("Test Case 003: Input data=0010");
        #1;

        check_outputs(4'h3, 4'h1);
    end
        endtask

    task testcase004;

    begin
        data = 4'b0011;
        $display("Test Case 004: Input data=0011");
        #1;

        check_outputs(4'h3, 4'h3);
    end
        endtask

    task testcase005;

    begin
        data = 4'b0100;
        $display("Test Case 005: Input data=0100");
        #1;

        check_outputs(4'h1, 4'hF);
    end
        endtask

    task testcase006;

    begin
        data = 4'b0101;
        $display("Test Case 006: Input data=0101");
        #1;

        check_outputs(4'h1, 4'hD);
    end
        endtask

    task testcase007;

    begin
        data = 4'b0110;
        $display("Test Case 007: Input data=0110");
        #1;

        check_outputs(4'h3, 4'hF);
    end
        endtask

    task testcase008;

    begin
        data = 4'b0111;
        $display("Test Case 008: Input data=0111");
        #1;

        check_outputs(4'h3, 4'hD);
    end
        endtask

    task testcase009;

    begin
        data = 4'b1000;
        $display("Test Case 009: Input data=1000");
        #1;

        check_outputs(4'hF, 4'h1);
    end
        endtask

    task testcase010;

    begin
        data = 4'b1001;
        $display("Test Case 010: Input data=1001");
        #1;

        check_outputs(4'hF, 4'h3);
    end
        endtask

    task testcase011;

    begin
        data = 4'b1010;
        $display("Test Case 011: Input data=1010");
        #1;

        check_outputs(4'hD, 4'h1);
    end
        endtask

    task testcase012;

    begin
        data = 4'b1011;
        $display("Test Case 012: Input data=1011");
        #1;

        check_outputs(4'hD, 4'h3);
    end
        endtask

    task testcase013;

    begin
        data = 4'b1100;
        $display("Test Case 013: Input data=1100");
        #1;

        check_outputs(4'hF, 4'hF);
    end
        endtask

    task testcase014;

    begin
        data = 4'b1101;
        $display("Test Case 014: Input data=1101");
        #1;

        check_outputs(4'hF, 4'hD);
    end
        endtask

    task testcase015;

    begin
        data = 4'b1110;
        $display("Test Case 015: Input data=1110");
        #1;

        check_outputs(4'hD, 4'hF);
    end
        endtask

    task testcase016;

    begin
        data = 4'b1111;
        $display("Test Case 016: Input data=1111");
        #1;

        check_outputs(4'hD, 4'hD);
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
        input [3:0] expected_I;
        input [3:0] expected_Q;
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
