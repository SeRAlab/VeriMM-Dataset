`timescale 1ns/1ps

module VirtualMemoryDecoder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] virtual_address;
    wire [11:0] offset;
    wire [19:0] page_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryDecoder dut (
        .virtual_address(virtual_address),
        .offset(offset),
        .page_number(page_number)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Address", test_num);
            virtual_address = 32'h0000_0000;
            #1;

            check_outputs(12'h000, 20'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Address", test_num);
            virtual_address = 32'hFFFF_FFFF;
            #1;

            check_outputs(12'hFFF, 20'hFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Page, Maximum Offset (Boundary)", test_num);
            virtual_address = 32'h0000_0FFF;
            #1;

            check_outputs(12'hFFF, 20'h00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Page 1, Minimum Offset (Boundary)", test_num);
            virtual_address = 32'h0000_1000;
            #1;

            check_outputs(12'h000, 20'h00001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Hex Pattern A", test_num);
            virtual_address = 32'hABCD_E123;
            #1;

            check_outputs(12'h123, 20'hABCDE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Hex Pattern B", test_num);
            virtual_address = 32'h1234_5678;
            #1;

            check_outputs(12'h678, 20'h12345);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bit Pattern", test_num);
            virtual_address = 32'hAAAA_AAAA;
            #1;

            check_outputs(12'hAAA, 20'hAAAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSB and LSB Bits Set Only", test_num);
            virtual_address = 32'h8000_0001;
            #1;

            check_outputs(12'h001, 20'h80000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Middle Nibbles", test_num);
            virtual_address = 32'h00FF_F000;
            #1;

            check_outputs(12'h000, 20'h00FFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Page Max-1", test_num);
            virtual_address = 32'hFFFF_EABC;
            #1;

            check_outputs(12'hABC, 20'hFFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryDecoder Testbench");
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
        input [11:0] expected_offset;
        input [19:0] expected_page_number;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_offset === (expected_offset ^ offset ^ expected_offset) &&
                expected_page_number === (expected_page_number ^ page_number ^ expected_page_number)) begin
                $display("PASS");
                $display("  Outputs: offset=%h, page_number=%h",
                         offset, page_number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: offset=%h, page_number=%h",
                         expected_offset, expected_page_number);
                $display("  Got:      offset=%h, page_number=%h",
                         offset, page_number);
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
