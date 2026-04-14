`timescale 1ns/1ps

module virtual_memory_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] virtual_address;
    wire [11:0] offset;
    wire [3:0] page_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_decoder dut (
        .virtual_address(virtual_address),
        .offset(offset),
        .page_number(page_number)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Minimum Address (0x0000)", test_num);
        virtual_address = 16'h0000;
        #1;

        check_outputs(12'h000, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum Address (0xFFFF)", test_num);
        virtual_address = 16'hFFFF;
        #1;

        check_outputs(12'hFFF, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Start of Page 1 (0x1000)", test_num);
        virtual_address = 16'h1000;
        #1;

        check_outputs(12'h000, 4'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: End of Page 0 (0x0FFF)", test_num);
        virtual_address = 16'h0FFF;
        #1;

        check_outputs(12'hFFF, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Arbitrary Address (0xABCD)", test_num);
        virtual_address = 16'hABCD;
        #1;

        check_outputs(12'hBCD, 4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: High Page, Low Offset (0xE005)", test_num);
        virtual_address = 16'hE005;
        #1;

        check_outputs(12'h005, 4'hE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Low Page, High Offset (0x2F80)", test_num);
        virtual_address = 16'h2F80;
        #1;

        check_outputs(12'hF80, 4'h2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Bit Boundary check (0x8000)", test_num);
        virtual_address = 16'h8000;
        #1;

        check_outputs(12'h000, 4'h8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_decoder Testbench");
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
        input [11:0] expected_offset;
        input [3:0] expected_page_number;
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
