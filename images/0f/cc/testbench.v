`timescale 1ns/1ps

module crc32_generator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [31:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc32_generator dut (
        .data_in(data_in),
        .crc_out(crc_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        data_in = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LSB Set (0x00000001)", test_num);
        data_in = 32'h0000_0001;
        #1;

        check_outputs(32'h04C1_1DB7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: MSB Set (0x80000000)", test_num);
        data_in = 32'h8000_0000;
        #1;

        check_outputs(32'h7707_3096);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones (0xFFFFFFFF)", test_num);
        data_in = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'hCBF4_3926);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x12345678", test_num);
        data_in = 32'h1234_5678;
        #1;

        check_outputs(32'h1C6A_7D4E);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0xA5A5A5A5", test_num);
        data_in = 32'hA5A5_A5A5;
        #1;

        check_outputs(32'h3933_01B5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x5A5A5A5A", test_num);
        data_in = 32'h5A5A_5A5A;
        #1;

        check_outputs(32'h0106_2070);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0xDEADC0DE", test_num);
        data_in = 32'hDEAD_C0DE;
        #1;

        check_outputs(32'h379E_94B3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0xC0DEFADE", test_num);
        data_in = 32'hC0DE_FADE;
        #1;

        check_outputs(32'h790A_2B0E);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x00000002", test_num);
        data_in = 32'h0000_0002;
        #1;

        check_outputs(32'h0982_3B6E);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc32_generator Testbench");
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
        input [31:0] expected_crc_out;
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
