`timescale 1ns/1ps

module bin_to_bcd_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [4:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_bcd dut (
        .bin(bin),
        .bcd(bcd)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Input bin = 0", test_num);
        bin = 4'd0;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Input bin = 1", test_num);
        bin = 4'd1;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Input bin = 5", test_num);
        bin = 4'd5;
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Input bin = 9 (Boundary)", test_num);
        bin = 4'd9;
        #1;

        check_outputs(5'h09);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Input bin = 10 (Carry Case)", test_num);
        bin = 4'd10;
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Input bin = 11", test_num);
        bin = 4'd11;
        #1;

        check_outputs(5'h11);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Input bin = 12", test_num);
        bin = 4'd12;
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Input bin = 13", test_num);
        bin = 4'd13;
        #1;

        check_outputs(5'h13);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Input bin = 14", test_num);
        bin = 4'd14;
        #1;

        check_outputs(5'h14);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: Input bin = 15 (Max Value)", test_num);
        bin = 4'd15;
        #1;

        check_outputs(5'h15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_bcd Testbench");
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
        input [4:0] expected_bcd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h",
                         bcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h",
                         expected_bcd);
                $display("  Got:      bcd=%h",
                         bcd);
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
