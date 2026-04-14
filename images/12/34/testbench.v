`timescale 1ns/1ps

module vmu_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] virtual_address;
    wire [31:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vmu dut (
        .virtual_address(virtual_address),
        .physical_address(physical_address)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Base Virtual Address", test_num);
        virtual_address = 32'h0000_0000;

        #1;


        check_outputs(32'h1234_5000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Mid-page Offset", test_num);
        virtual_address = 32'h0000_0ABC;

        #1;


        check_outputs(32'h1234_5ABC);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Page Upper Boundary", test_num);
        virtual_address = 32'h0000_0FFF;

        #1;


        check_outputs(32'h1234_5FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Different VPN, Same PPN Mapping", test_num);
        virtual_address = 32'hABCD_E000;

        #1;


        check_outputs(32'h1234_5000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: High VPN with Offset", test_num);
        virtual_address = 32'hFFFF_F123;

        #1;


        check_outputs(32'h1234_5123);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Start of Virtual Page 1", test_num);
        virtual_address = 32'h0000_1000;

        #1;


        check_outputs(32'h1234_5000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vmu Testbench");
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
        input [31:0] expected_physical_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h",
                         physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h",
                         expected_physical_address);
                $display("  Got:      physical_address=%h",
                         physical_address);
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
