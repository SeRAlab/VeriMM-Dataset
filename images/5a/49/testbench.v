`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [3:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .bin(bin),
        .gray(gray)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 1: Binary 0000");
        bin = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 2: Binary 0001");
        bin = 4'b0001;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 3: Binary 0010");
        bin = 4'b0010;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 4: Binary 0011");
        bin = 4'b0011;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 5: Binary 0100");
        bin = 4'b0100;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 6: Binary 0111");
        bin = 4'b0111;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 7: Binary 1000");
        bin = 4'b1000;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 8: Binary 1001");
        bin = 4'b1001;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 9: Binary 1010");
        bin = 4'b1010;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 10: Binary 1100");
        bin = 4'b1100;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 11: Binary 1101");
        bin = 4'b1101;
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 12: Binary 1111");
        bin = 4'b1111;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_gray Testbench");
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
        input [3:0] expected_gray;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
