`timescale 1ns/1ps

module usbf_crc16_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] crc_in_i;
    reg [7:0] din_i;
    wire [15:0] crc_out_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    usbf_crc16 dut (
        .crc_in_i(crc_in_i),
        .din_i(din_i),
        .crc_out_o(crc_out_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            crc_in_i = 16'h0000;
            din_i = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: USB Initialization with Zero Data", test_num);

            crc_in_i = 16'hffff;
            din_i = 8'h00;
            #1;

            check_outputs(16'h1f00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Zero Init with LSB Set", test_num);
            crc_in_i = 16'h0000;
            din_i = 8'h01;
            #1;

            check_outputs(16'hc001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero Init with MSB Set", test_num);
            crc_in_i = 16'h0000;
            din_i = 8'h80;
            #1;

            check_outputs(16'h01c0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: USB Initialization with All Ones Data", test_num);
            crc_in_i = 16'hffff;
            din_i = 8'hff;
            #1;

            check_outputs(16'he1ff);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Random Pattern 1", test_num);
            crc_in_i = 16'h1234;
            din_i = 8'h56;
            #1;

            check_outputs(16'h9331);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Random Pattern 2", test_num);
            crc_in_i = 16'hABCD;
            din_i = 8'h23;
            #1;

            check_outputs(16'h3774);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Data Chain (Propagating CRC)", test_num);

            crc_in_i = 16'hffff;
            din_i = 8'h80;
            #2;

            crc_in_i = crc_out_o;
            din_i = 8'h06;
            #1;

            check_outputs(16'h7092);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("usbf_crc16 Testbench");
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
        input [15:0] expected_crc_out_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_out_o === (expected_crc_out_o ^ crc_out_o ^ expected_crc_out_o)) begin
                $display("PASS");
                $display("  Outputs: crc_out_o=%h",
                         crc_out_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out_o=%h",
                         expected_crc_out_o);
                $display("  Got:      crc_out_o=%h",
                         crc_out_o);
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
