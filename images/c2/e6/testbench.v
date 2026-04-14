`timescale 1ns/1ps

module fletcher_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fletcher dut (
        .data(data),
        .checksum(checksum)
    );
    task testcase001;

        begin
            $display("\nRunning Testcase 001: All Zeros");
            test_num = 1;
            data = 32'h00000000;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Simple Incremental Sequence (01, 02, 03, 04)");
            test_num = 2;
            data = 32'h01020304;




            #1;





            check_outputs(16'h140A);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Constant Values (All 0x11)");
            test_num = 3;
            data = 32'h11111111;




            #1;





            check_outputs(16'hAA44);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Maximum Values (Overflow Test)");
            test_num = 4;
            data = 32'hFFFFFFFF;




            #1;





            check_outputs(16'hF6FC);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Mixed Data (0x12345678)");
            test_num = 5;
            data = 32'h12345678;




            #1;





            check_outputs(16'h0814);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fletcher Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
