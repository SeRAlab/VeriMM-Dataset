`timescale 1ns/1ps

module crc16_generator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    reg [15:0] polynomial;
    wire [15:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc16_generator dut (
        .data(data),
        .polynomial(polynomial),
        .crc(crc)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        data = 16'h0000;
        polynomial = 16'h1021;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single LSB Bit (CRC-16-CCITT)", test_num);
        data = 16'h0001;
        polynomial = 16'h1021;

        #1;


        check_outputs(16'h1021);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single MSB Bit (CRC-16-CCITT)", test_num);
        data = 16'h8000;
        polynomial = 16'h1021;

        #1;


        check_outputs(16'h9479);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones (CRC-16-CCITT)", test_num);
        data = 16'hFFFF;
        polynomial = 16'h1021;

        #1;


        check_outputs(16'h1D0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Data (CRC-16-CCITT)", test_num);
        data = 16'h1234;
        polynomial = 16'h1021;

        #1;


        check_outputs(16'h138A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternate Polynomial (CRC-16-IBM)", test_num);
        data = 16'h0001;
        polynomial = 16'h8005;

        #1;


        check_outputs(16'h8005);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Data (CRC-16-IBM)", test_num);
        data = 16'h1234;
        polynomial = 16'h8005;

        #1;


        check_outputs(16'hED78);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Pattern (CRC-16-CCITT)", test_num);
        data = 16'h5555;
        polynomial = 16'h1021;

        #1;


        check_outputs(16'h2A19);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc16_generator Testbench");
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
        input [15:0] expected_crc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
