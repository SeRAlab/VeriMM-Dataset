`timescale 1ns/1ps

module mmu_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] virtual_address;
    wire page_fault;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mmu dut (
        .virtual_address(virtual_address),
        .page_fault(page_fault),
        .physical_address(physical_address)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Translation Page 0", test_num);
            virtual_address = 8'h05;
            #1;

            check_outputs(1'b0, 8'h75);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Translation Page 3", test_num);
            virtual_address = 8'h3A;
            #1;

            check_outputs(1'b0, 8'h4A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Translation Page 7 (Upper Bound)", test_num);
            virtual_address = 8'h7F;
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Page Fault Detection (VPN 8)", test_num);
            virtual_address = 8'h80;


            #1;



            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Page Fault Detection (VPN 15)", test_num);
            virtual_address = 8'hFF;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mmu Testbench");
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
        input expected_page_fault;
        input [7:0] expected_physical_address;
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
