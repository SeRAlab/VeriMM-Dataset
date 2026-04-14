`timescale 1ns/1ps

module binary_to_bcd_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [7:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_bcd dut (
        .bin(bin),
        .bcd(bcd)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        bin = 4'd0;
        $display("Test %0d: Input bin = %d (Zero)", test_num, bin);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        bin = 4'd5;
        $display("Test %0d: Input bin = %d (Single Digit)", test_num, bin);
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        bin = 4'd9;
        $display("Test %0d: Input bin = %d (Max Single Digit)", test_num, bin);
        #1;

        check_outputs(8'h09);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        bin = 4'd10;
        $display("Test %0d: Input bin = %d (Min Double Digit)", test_num, bin);
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        bin = 4'd12;
        $display("Test %0d: Input bin = %d", test_num, bin);
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        bin = 4'd15;
        $display("Test %0d: Input bin = %d (Max 4-bit Value)", test_num, bin);
        #1;

        check_outputs(8'h15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_bcd Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_bcd;
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
