`timescale 1ns/1ps

module gray_to_binary_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] G;
    wire [3:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_to_binary dut (
        .G(G),
        .B(B)
    );
    task testcase001;

    begin
        test_num = 1;
        G = 4'b0000;
        $display("Test Case 001: G=0000 (Gray)");
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        G = 4'b0001;
        $display("Test Case 002: G=0001 (Gray)");
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        G = 4'b0011;
        $display("Test Case 003: G=0011 (Gray)");
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        G = 4'b0010;
        $display("Test Case 004: G=0010 (Gray)");
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        G = 4'b0110;
        $display("Test Case 005: G=0110 (Gray)");
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        G = 4'b0111;
        $display("Test Case 006: G=0111 (Gray)");
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        G = 4'b0101;
        $display("Test Case 007: G=0101 (Gray)");
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        G = 4'b0100;
        $display("Test Case 008: G=0100 (Gray)");
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        G = 4'b1100;
        $display("Test Case 009: G=1100 (Gray)");
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        G = 4'b1101;
        $display("Test Case 010: G=1101 (Gray)");
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        G = 4'b1111;
        $display("Test Case 011: G=1111 (Gray)");
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        G = 4'b1110;
        $display("Test Case 012: G=1110 (Gray)");
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        G = 4'b1010;
        $display("Test Case 013: G=1010 (Gray)");
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        G = 4'b1011;
        $display("Test Case 014: G=1011 (Gray)");
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        G = 4'b1001;
        $display("Test Case 015: G=1001 (Gray)");
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        G = 4'b1000;
        $display("Test Case 016: G=1000 (Gray)");
        #1;

        check_outputs(4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_to_binary Testbench");
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
        input [3:0] expected_B;
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
