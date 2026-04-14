`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] bin;
    wire [4:0] gray;

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
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b00000 (0)", test_num);
        bin = 5'b00000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b00001 (1)", test_num);
        bin = 5'b00001;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b00010 (2)", test_num);
        bin = 5'b00010;
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b00011 (3)", test_num);
        bin = 5'b00011;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b00111 (7)", test_num);
        bin = 5'b00111;
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b01111 (15)", test_num);
        bin = 5'b01111;
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b10000 (16)", test_num);
        bin = 5'b10000;
        #1;

        check_outputs(5'b11000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b11111 (31)", test_num);
        bin = 5'b11111;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b10101 (21)", test_num);
        bin = 5'b10101;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bin = 5'b01010 (10)", test_num);
        bin = 5'b01010;
        #1;

        check_outputs(5'b01111);
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
        input [4:0] expected_gray;
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
