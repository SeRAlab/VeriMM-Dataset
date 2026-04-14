`timescale 1ns/1ps

module usbh_crc16_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] crc_i;
    reg [7:0] data_i;
    wire [15:0] crc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    usbh_crc16 dut (
        .crc_i(crc_i),
        .data_i(data_i),
        .crc_o(crc_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (Reset state check)", test_num);

            crc_i = 16'h0000;
            data_i = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard USB Seed with Zero Data", test_num);
            crc_i = 16'hFFFF;
            data_i = 8'h00;
            #1;

            check_outputs(16'h1EFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit (LSB) Data Input", test_num);
            crc_i = 16'h0000;
            data_i = 8'h01;
            #1;

            check_outputs(16'hC001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit (MSB) Data Input", test_num);
            crc_i = 16'h0000;
            data_i = 8'h80;
            #1;

            check_outputs(16'h0180);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Data Byte (0xFF) with Zero Seed", test_num);
            crc_i = 16'h0000;
            data_i = 8'hFF;
            #1;

            check_outputs(16'hC181);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ASCII 'A' (0x41) with Standard Seed", test_num);
            crc_i = 16'hFFFF;
            data_i = 8'h41;
            #1;

            check_outputs(16'h9451);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Chained Calculation (Byte 2 of 'AB')", test_num);

            crc_i = 16'h9451;
            data_i = 8'h42;
            #1;

            check_outputs(16'h269E);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Chained Zeros (Two byte null packet sequence)", test_num);

            crc_i = 16'h1EFE;
            data_i = 8'h00;
            #1;

            check_outputs(16'h0E7E);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Seed, High Data", test_num);
            crc_i = 16'hFFFF;
            data_i = 8'hFF;
            #1;

            check_outputs(16'h1EFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("usbh_crc16 Testbench");
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
        input [15:0] expected_crc_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_o === (expected_crc_o ^ crc_o ^ expected_crc_o)) begin
                $display("PASS");
                $display("  Outputs: crc_o=%h",
                         crc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_o=%h",
                         expected_crc_o);
                $display("  Got:      crc_o=%h",
                         crc_o);
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
