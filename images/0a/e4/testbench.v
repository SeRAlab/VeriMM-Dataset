`timescale 1ns/1ps

module nat_classifier_tb;

    // Testbench signals (combinational circuit)
    reg isPortMapped;
    reg isPublicIP;
    wire [1:0] natType;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_classifier dut (
        .isPortMapped(isPortMapped),
        .isPublicIP(isPublicIP),
        .natType(natType)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Open NAT (isPublicIP=1, isPortMapped=1)");
        isPublicIP = 1;
        isPortMapped = 1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Moderate NAT (isPublicIP=1, isPortMapped=0)");
        isPublicIP = 1;
        isPortMapped = 0;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Strict NAT (isPublicIP=0, isPortMapped=1)");
        isPublicIP = 0;
        isPortMapped = 1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Unclassified NAT (isPublicIP=0, isPortMapped=0)");
        isPublicIP = 0;
        isPortMapped = 0;
        #1;

        check_outputs(2'b11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_classifier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [1:0] expected_natType;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_natType === (expected_natType ^ natType ^ expected_natType)) begin
                $display("PASS");
                $display("  Outputs: natType=%h",
                         natType);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: natType=%h",
                         expected_natType);
                $display("  Got:      natType=%h",
                         natType);
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
