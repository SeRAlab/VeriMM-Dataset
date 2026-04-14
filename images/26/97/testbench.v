`timescale 1ns/1ps

module qam_mapper_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [2:0] I;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_mapper dut (
        .symbol(symbol),
        .I(I),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Symbol 0000");
        symbol = 4'b0000;
        #1;

        check_outputs(3'b000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Symbol 0001");
        symbol = 4'b0001;
        #1;

        check_outputs(3'b000, 3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Symbol 0010");
        symbol = 4'b0010;
        #1;

        check_outputs(3'b001, 3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Symbol 0011");
        symbol = 4'b0011;
        #1;

        check_outputs(3'b001, 3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Symbol 0100");
        symbol = 4'b0100;
        #1;

        check_outputs(3'b010, 3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Symbol 0101");
        symbol = 4'b0101;
        #1;

        check_outputs(3'b010, 3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Symbol 0110");
        symbol = 4'b0110;
        #1;

        check_outputs(3'b011, 3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Symbol 0111");
        symbol = 4'b0111;
        #1;

        check_outputs(3'b011, 3'b001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Symbol 1000");
        symbol = 4'b1000;
        #1;

        check_outputs(3'b100, 3'b000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Symbol 1001");
        symbol = 4'b1001;
        #1;

        check_outputs(3'b100, 3'b001);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case 011: Symbol 1010");
        symbol = 4'b1010;
        #1;

        check_outputs(3'b101, 3'b000);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case 012: Symbol 1011");
        symbol = 4'b1011;
        #1;

        check_outputs(3'b101, 3'b001);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case 013: Symbol 1100");
        symbol = 4'b1100;
        #1;

        check_outputs(3'b110, 3'b000);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test Case 014: Symbol 1101");
        symbol = 4'b1101;
        #1;

        check_outputs(3'b110, 3'b001);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test Case 015: Symbol 1110");
        symbol = 4'b1110;
        #1;

        check_outputs(3'b111, 3'b000);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Test Case 016: Symbol 1111");
        symbol = 4'b1111;
        #1;

        check_outputs(3'b111, 3'b001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_mapper Testbench");
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
        input [2:0] expected_I;
        input [2:0] expected_Q;
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
