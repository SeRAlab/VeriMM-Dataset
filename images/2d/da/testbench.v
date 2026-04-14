`timescale 1ns/1ps

module pcie_address_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] address;
    wire [3:0] cs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_address_decoder dut (
        .address(address),
        .cs(cs)
    );
    task testcase001;

        begin
            test_num = 1;
            address = 32'h0000_0000;
            $display("Running Testcase %0d: Device 0 Min Address", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            address = 32'h3FFF_FFFF;
            $display("Running Testcase %0d: Device 0 Max Address", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            address = 32'h4000_0000;
            $display("Running Testcase %0d: Device 1 Min Address", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            address = 32'h7FFF_FFFF;
            $display("Running Testcase %0d: Device 1 Max Address", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            address = 32'h8000_0000;
            $display("Running Testcase %0d: Device 2 Min Address", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            address = 32'hBFFF_FFFF;
            $display("Running Testcase %0d: Device 2 Max Address", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            address = 32'hC000_0000;
            $display("Running Testcase %0d: Device 3 Min Address", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            address = 32'hFFFF_FFFF;
            $display("Running Testcase %0d: Device 3 Max Address", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            address = 32'h5A5A_A5A5;
            $display("Running Testcase %0d: Device 1 Random Address", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            address = 32'h90ABCDEF;
            $display("Running Testcase %0d: Device 2 Random Address", test_num);
            #1;

            check_outputs(4'b0100);
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
        input [3:0] expected_cs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cs === (expected_cs ^ cs ^ expected_cs)) begin
                $display("PASS");
                $display("  Outputs: cs=%h",
                         cs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%h",
                         expected_cs);
                $display("  Got:      cs=%h",
                         cs);
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
