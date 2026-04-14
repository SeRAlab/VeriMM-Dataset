`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addr;
    reg [15:0] addr16;
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out1;
    wire [7:0] data_out2;
    wire [7:0] data_out3;
    wire [7:0] data_out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .addr16(addr16),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .data_out3(data_out3),
        .data_out4(data_out4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write to 8-bit address 0x11", test_num);

            addr16 = 16'h0000;

            addr = 8'h11;
            data_in = 8'hA1;
            write_enable = 1;
            #10;
            write_enable = 0;
            #5;
            #1;

            check_outputs(8'hA1, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to 8-bit address 0x22", test_num);

            addr = 8'h22;
            data_in = 8'hB2;
            write_enable = 1;
            #10;
            write_enable = 0;
            #5;
            #1;

            check_outputs(8'hA1, 8'hB2, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write to 16-bit address 0x0011", test_num);

            addr = 8'h00;
            addr16 = 16'h0011;
            data_in = 8'hC3;
            write_enable = 1;
            #10;
            write_enable = 0;
            #5;
            #1;

            check_outputs(8'hA1, 8'hB2, 8'hC3, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write to 16-bit address 0x0022", test_num);
            addr16 = 16'h0022;
            data_in = 8'hD4;
            write_enable = 1;
            #10;
            write_enable = 0;
            #5;
            #1;

            check_outputs(8'hA1, 8'hB2, 8'hC3, 8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable Low Test (No change expected)", test_num);
            addr = 8'h11;
            data_in = 8'hFF;
            write_enable = 0;
            #10;
            #1;

            check_outputs(8'hA1, 8'hB2, 8'hC3, 8'hD4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Invalid 8-bit Address Test", test_num);
            addr = 8'hFF;
            data_in = 8'hEE;
            write_enable = 1;
            #10;
            write_enable = 0;
            #5;
            #1;

            check_outputs(8'hA1, 8'hB2, 8'hC3, 8'hD4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Invalid 16-bit Address Test", test_num);
            addr = 8'h00;
            addr16 = 16'hFFFF;
            data_in = 8'h99;
            write_enable = 1;
            #10;
            write_enable = 0;
            #5;
            #1;

            check_outputs(8'hA1, 8'hB2, 8'hC3, 8'hD4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Overwriting data_out3 (addr16 0x0011)", test_num);
            addr16 = 16'h0011;
            data_in = 8'h77;
            write_enable = 1;
            #10;
            write_enable = 0;
            #5;
            #1;

            check_outputs(8'hA1, 8'hB2, 8'h77, 8'hD4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        input [7:0] expected_data_out3;
        input [7:0] expected_data_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_data_out3 === (expected_data_out3 ^ data_out3 ^ expected_data_out3) &&
                expected_data_out4 === (expected_data_out4 ^ data_out4 ^ expected_data_out4)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h",
                         data_out1, data_out2, data_out3, data_out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h",
                         expected_data_out1, expected_data_out2, expected_data_out3, expected_data_out4);
                $display("  Got:      data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h",
                         data_out1, data_out2, data_out3, data_out4);
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
