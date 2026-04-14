`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [79:0] data;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data(data),
        .checksum(checksum)
    );
    task testcase001;

        begin
            test_num = 1;
            data = {16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000};
            $display("Test Case %0d: All Zeros", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = {16'h0001, 16'h0002, 16'h0003, 16'h0004, 16'h0005};
            $display("Test Case %0d: Simple Incrementing Values", test_num);
            #1;

            check_outputs(16'hFFF0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = {16'hFFFF, 16'h0001, 16'h0000, 16'h0000, 16'h0000};
            $display("Test Case %0d: Single Carry Wrap", test_num);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = {16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF};
            $display("Test Case %0d: All Maximum Values", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = {16'h4500, 16'h003C, 16'h1C46, 16'h4000, 16'h4006};
            $display("Test Case %0d: IP Header Snippet", test_num);
            #1;

            check_outputs(16'h1E77);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = {16'h1234, 16'h5678, 16'h9ABC, 16'hDEF0, 16'h1111};
            $display("Test Case %0d: Mixed Values with Carry", test_num);
            #1;

            check_outputs(16'h0C95);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
