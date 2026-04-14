`timescale 1ns/1ps

module pcie_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] address;
    wire [3:0] enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_decoder dut (
        .address(address),
        .enable(enable)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address = 0", test_num);
            address = 4'd0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address = 1", test_num);
            address = 4'd1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address = 2", test_num);
            address = 4'd2;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address = 3", test_num);
            address = 4'd3;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address = 4", test_num);
            address = 4'd4;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address = 7", test_num);
            address = 4'd7;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address = 15", test_num);
            address = 4'd15;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enable === (expected_enable ^ enable ^ expected_enable)) begin
                $display("PASS");
                $display("  Outputs: enable=%h",
                         enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable=%h",
                         expected_enable);
                $display("  Got:      enable=%h",
                         enable);
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
