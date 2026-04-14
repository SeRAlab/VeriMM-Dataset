`timescale 1ns/1ps

module pcie_address_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] address;
    wire [3:0] chip_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_address_decoder dut (
        .address(address),
        .chip_select(chip_select)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0x00000000 - Base case", test_num);
            address = 32'h00000000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0x0000000F - Upper boundary of device range", test_num);
            address = 32'h0000000F;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0x12345678 - Random address with mid-range select", test_num);
            address = 32'h12345678;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0xFFFFFFF5 - High address bits set", test_num);
            address = 32'hFFFFFFF5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0xAAAAAAA1 - Alternating high bits", test_num);
            address = 32'hAAAAAAA1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0x5555555A - Alternating bits with select 10", test_num);
            address = 32'h5555555A;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0x00000007 - Single bit in lower nibble", test_num);
            address = 32'h00000007;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address 0xDEADC0DE - Specific pattern check", test_num);
            address = 32'hDEADC0DE;
            #1;

            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_address_decoder Testbench");
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
        input [3:0] expected_chip_select;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_chip_select === (expected_chip_select ^ chip_select ^ expected_chip_select)) begin
                $display("PASS");
                $display("  Outputs: chip_select=%h",
                         chip_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chip_select=%h",
                         expected_chip_select);
                $display("  Got:      chip_select=%h",
                         chip_select);
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
