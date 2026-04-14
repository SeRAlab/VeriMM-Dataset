`timescale 1ns/1ps

module shift_1b_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_data;
    reg i_shift;
    wire [31:0] o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_1b dut (
        .i_data(i_data),
        .i_shift(i_shift),
        .o_data(o_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Pass-through mode with 0x00000000");
            i_data = 32'h0000_0000;
            i_shift = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Shift mode with 0x00000000");
            i_data = 32'h0000_0000;
            i_shift = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Pass-through mode with 0xFFFFFFFF");
            i_data = 32'hFFFF_FFFF;
            i_shift = 1'b0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Shift mode with 0xFFFFFFFF");
            i_data = 32'hFFFF_FFFF;
            i_shift = 1'b1;
            #1;

            check_outputs(32'h7FFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Shift mode with LSB only (0x00000001)");
            i_data = 32'h0000_0001;
            i_shift = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Shift mode with MSB only (0x80000000)");
            i_data = 32'h8000_0000;
            i_shift = 1'b1;
            #1;

            check_outputs(32'h4000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Pass-through mode with 0xAAAAAAAA");
            i_data = 32'hAAAA_AAAA;
            i_shift = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Shift mode with 0xAAAAAAAA");
            i_data = 32'hAAAA_AAAA;
            i_shift = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Shift mode with 0x12345678");
            i_data = 32'h1234_5678;
            i_shift = 1'b1;
            #1;

            check_outputs(32'h091A_2B3C);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: Shift mode with 0x00000002");
            i_data = 32'h0000_0002;
            i_shift = 1'b1;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_1b Testbench");
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
        input [31:0] expected_o_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h",
                         o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h",
                         expected_o_data);
                $display("  Got:      o_data=%h",
                         o_data);
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
