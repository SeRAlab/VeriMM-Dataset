`timescale 1ns/1ps

module pcie_address_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] address;
    wire [3:0] range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_address_decoder dut (
        .address(address),
        .range(range)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lower bound of Range 0", test_num);
        address = 32'h0000_0000;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Upper bound of Range 0", test_num);
        address = 32'h0FFF_FFFF;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition to Range 1", test_num);
        address = 32'h1000_0000;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random address in Range 5", test_num);
        address = 32'h5A5A_BEEF;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 8 (MSB set)", test_num);
        address = 32'h8000_0000;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random address in Range 10 (A)", test_num);
        address = 32'hA234_5678;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random address in Range 13 (D)", test_num);
        address = 32'hD000_0001;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lower bound of Range 15 (F)", test_num);
        address = 32'hF000_0000;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Midpoint of Range 15 (F)", test_num);
        address = 32'hF789_ABCD;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Absolute maximum address (Range 15)", test_num);
        address = 32'hFFFF_FFFF;
        #1;

        check_outputs(4'hF);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_range;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_range === (expected_range ^ range ^ expected_range)) begin
                $display("PASS");
                $display("  Outputs: range=%h",
                         range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range=%h",
                         expected_range);
                $display("  Got:      range=%h",
                         range);
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
