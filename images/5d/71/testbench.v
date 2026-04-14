`timescale 1ns/1ps

module bin_to_gray_6bit_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] bin;
    wire [5:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_gray_6bit dut (
        .bin(bin),
        .gray(gray)
    );
    task testcase001;

    begin
        test_num = 1;
        bin = 6'b000000;
        $display("Test Case %0d: bin = %b", test_num, bin);
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bin = 6'b111111;
        $display("Test Case %0d: bin = %b", test_num, bin);
        #1;

        check_outputs(6'b100000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bin = 6'd7;
        $display("Test Case %0d: bin = %d", test_num, bin);
        #1;

        check_outputs(6'b000100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bin = 6'd8;
        $display("Test Case %0d: bin = %d", test_num, bin);
        #1;

        check_outputs(6'b001100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bin = 6'd31;
        $display("Test Case %0d: bin = %d", test_num, bin);
        #1;

        check_outputs(6'b010000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bin = 6'd32;
        $display("Test Case %0d: bin = %d", test_num, bin);
        #1;

        check_outputs(6'b110000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bin = 6'b101010;
        $display("Test Case %0d: bin = %b", test_num, bin);
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bin = 6'b010101;
        $display("Test Case %0d: bin = %b", test_num, bin);
        #1;

        check_outputs(6'b011111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bin = 6'b000001;
        $display("Test Case %0d: bin = %b", test_num, bin);
        #1;

        check_outputs(6'b000001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bin = 6'b110011;
        $display("Test Case %0d: bin = %b", test_num, bin);
        #1;

        check_outputs(6'b101010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_gray_6bit Testbench");
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
        input [5:0] expected_gray;
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
