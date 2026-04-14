`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    wire [7:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .data(data),
        .crc(crc)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Data = 0x00");
        data = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Data = 0x01");
        data = 8'h01;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Data = 0x02");
        data = 8'h02;
        #1;

        check_outputs(8'h0E);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Data = 0x04");
        data = 8'h04;
        #1;

        check_outputs(8'h1C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Data = 0x08");
        data = 8'h08;
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Data = 0x10");
        data = 8'h10;
        #1;

        check_outputs(8'h70);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Data = 0x20");
        data = 8'h20;
        #1;

        check_outputs(8'hE0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Data = 0x40");
        data = 8'h40;
        #1;

        check_outputs(8'hC7);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Data = 0x80");
        data = 8'h80;
        #1;

        check_outputs(8'h89);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Data = 0xFF");
        data = 8'hFF;
        #1;

        check_outputs(8'hF3);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case 011: Data = 0x55");
        data = 8'h55;
        #1;

        check_outputs(8'hAC);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case 012: Data = 0xAA");
        data = 8'hAA;
        #1;

        check_outputs(8'h5F);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case 013: Data = 0x12");
        data = 8'h12;
        #1;

        check_outputs(8'h7E);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [7:0] expected_crc;
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
