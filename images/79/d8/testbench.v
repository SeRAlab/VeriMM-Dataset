`timescale 1ns/1ps

module bin2seven_segment_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [6:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin2seven_segment dut (
        .bin(bin),
        .segments(segments)
    );
    task testcase001;

    begin
        test_num = 1;
        bin = 4'h0;
        $display("Test Case 001: Testing binary 0");
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bin = 4'h1;
        $display("Test Case 002: Testing binary 1");
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bin = 4'h2;
        $display("Test Case 003: Testing binary 2");
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bin = 4'h3;
        $display("Test Case 004: Testing binary 3");
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bin = 4'h4;
        $display("Test Case 005: Testing binary 4");
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bin = 4'h5;
        $display("Test Case 006: Testing binary 5");
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bin = 4'h6;
        $display("Test Case 007: Testing binary 6");
        #1;

        check_outputs(7'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bin = 4'h7;
        $display("Test Case 008: Testing binary 7");
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bin = 4'h8;
        $display("Test Case 009: Testing binary 8");
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bin = 4'h9;
        $display("Test Case 010: Testing binary 9");
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        bin = 4'hA;
        $display("Test Case 011: Testing binary A");
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        bin = 4'hB;
        $display("Test Case 012: Testing binary B");
        #1;

        check_outputs(7'h7C);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        bin = 4'hC;
        $display("Test Case 013: Testing binary C");
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        bin = 4'hD;
        $display("Test Case 014: Testing binary D");
        #1;

        check_outputs(7'h5E);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        bin = 4'hE;
        $display("Test Case 015: Testing binary E");
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        bin = 4'hF;
        $display("Test Case 016: Testing binary F");
        #1;

        check_outputs(7'h71);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin2seven_segment Testbench");
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
        input [6:0] expected_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: segments=%h",
                         segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segments=%h",
                         expected_segments);
                $display("  Got:      segments=%h",
                         segments);
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
