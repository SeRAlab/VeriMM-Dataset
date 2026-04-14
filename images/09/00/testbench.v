`timescale 1ns/1ps

module VirtualMemoryManagement_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] virtual_address;
    wire page_fault;
    wire [3:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManagement dut (
        .virtual_address(virtual_address),
        .page_fault(page_fault),
        .physical_address(physical_address)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 0 (Present), Offset 0", test_num);
        virtual_address = 4'b00_00;
        #1;

        check_outputs(1'b0, 4'b10_00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 0 (Present), Offset 3", test_num);
        virtual_address = 4'b00_11;
        #1;

        check_outputs(1'b0, 4'b10_11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 1 (Not Present) - Page Fault", test_num);
        virtual_address = 4'b01_00;
        #1;

        check_outputs(1'b1, 4'b00_00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 2 (Present), Offset 1", test_num);
        virtual_address = 4'b10_01;
        #1;

        check_outputs(1'b0, 4'b11_01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 3 (Present), Offset 2", test_num);
        virtual_address = 4'b11_10;
        #1;

        check_outputs(1'b0, 4'b00_10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 1 (Not Present), Offset 3 - Page Fault", test_num);
        virtual_address = 4'b01_11;
        #1;

        check_outputs(1'b1, 4'b00_00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 2 (Present), Offset 3", test_num);
        virtual_address = 4'b10_11;
        #1;

        check_outputs(1'b0, 4'b11_11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing VPN 3 (Present), Offset 0", test_num);
        virtual_address = 4'b11_00;
        #1;

        check_outputs(1'b0, 4'b00_00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManagement Testbench");
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
        input expected_page_fault;
        input [3:0] expected_physical_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: page_fault=%b, physical_address=%h",
                         page_fault, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: page_fault=%b, physical_address=%h",
                         expected_page_fault, expected_physical_address);
                $display("  Got:      page_fault=%b, physical_address=%h",
                         page_fault, physical_address);
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
