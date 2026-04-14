`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    wire [15:0] crc;

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
        $display("Test %0d: Input Data = 0x0000 (Zero input)", test_num);
        data = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0x0001 (LSB set)", test_num);
        data = 16'h0001;
        #1;

        check_outputs(16'h1021);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0x0002", test_num);
        data = 16'h0002;
        #1;

        check_outputs(16'h2042);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0xFFFF (All ones)", test_num);
        data = 16'hFFFF;
        #1;

        check_outputs(16'h1D0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0x1234 (Arbitrary pattern)", test_num);
        data = 16'h1234;
        #1;

        check_outputs(16'h1351);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0xABCD (Arbitrary pattern)", test_num);
        data = 16'hABCD;
        #1;

        check_outputs(16'h1D73);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0xAAAA (Alternating bits)", test_num);
        data = 16'hAAAA;
        #1;

        check_outputs(16'h3210);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0x5555 (Alternating bits)", test_num);
        data = 16'h5555;
        #1;

        check_outputs(16'h2231);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Data = 0x8000 (MSB set)", test_num);
        data = 16'h8000;
        #1;

        check_outputs(16'h9479);
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
