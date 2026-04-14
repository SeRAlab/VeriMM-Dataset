`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .data_in(data_in),
        .crc_out(crc_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 8'h00;
            $display("Test %0d: Input 0x00 (Zero Input)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 8'h01;
            $display("Test %0d: Input 0x01 (LSB set)", test_num);
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 8'h02;
            $display("Test %0d: Input 0x02", test_num);
            #1;

            check_outputs(8'h0E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 8'h80;
            $display("Test %0d: Input 0x80 (MSB set)", test_num);
            #1;

            check_outputs(8'h89);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 8'hFF;
            $display("Test %0d: Input 0xFF (All bits set)", test_num);
            #1;

            check_outputs(8'hF1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 8'hAA;
            $display("Test %0d: Input 0xAA (Alternating pattern 1010...)", test_num);
            #1;

            check_outputs(8'h3E);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 8'h55;
            $display("Test %0d: Input 0x55 (Alternating pattern 0101...)", test_num);
            #1;

            check_outputs(8'h7B);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 8'h12;
            $display("Test %0d: Input 0x12", test_num);
            #1;

            check_outputs(8'h50);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 8'h34;
            $display("Test %0d: Input 0x34", test_num);
            #1;

            check_outputs(8'hB0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 8'hBE;
            $display("Test %0d: Input 0xBE", test_num);
            #1;

            check_outputs(8'hAD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [7:0] expected_crc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
