`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data_in(data_in),
        .checksum(checksum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All Zeros");
        data_in = 32'h0000_0000;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: All Ones");
        data_in = 32'hFFFF_FFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Simple Addition (No Carry)");
        data_in = 32'h1234_5678;
        #1;

        check_outputs(16'h9753);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Addition with Wrap-around Carry");
        data_in = 32'hABCD_EF01;
        #1;

        check_outputs(16'h6530);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Maximum Carry-out (FFFF + 0001)");
        data_in = 32'hFFFF_0001;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: IP Header Fragment Simulation");
        data_in = 32'h4500_003C;
        #1;

        check_outputs(16'hBAC3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Symmetric High-Bit Carry");
        data_in = 32'h8000_8000;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Small Values");
        data_in = 32'h0001_0001;
        #1;

        check_outputs(16'hFFFD);
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
        testcase007();
        testcase008();
        
        
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
