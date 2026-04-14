`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg enable;
    wire [7:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .data(data),
        .enable(enable),
        .checksum(checksum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: All zeros, enable high", test_num);

        data = 8'h00;
        enable = 0;
        #5;

        enable = 1;
        data = 8'b0000_0000;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: All ones, enable high", test_num);

        data = 8'h00;
        enable = 0;
        #5;

        enable = 1;
        data = 8'b1111_1111;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Alternating bits (0xAA), enable high", test_num);

        data = 8'h00;
        enable = 0;
        #5;

        enable = 1;
        data = 8'b1010_1010;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Data change while enable is low (Latch test)", test_num);

        data = 8'b0000_0111;
        enable = 1;
        #5;

        enable = 0;
        data = 8'b1111_1111;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Re-enabling after hold state", test_num);

        data = 8'b1111_1111;
        enable = 0;
        #5;

        enable = 1;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Multiple bits set (0x71), enable high", test_num);

        data = 8'h00;
        enable = 0;
        #5;

        enable = 1;
        data = 8'h71;
        #1;

        check_outputs(8'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
