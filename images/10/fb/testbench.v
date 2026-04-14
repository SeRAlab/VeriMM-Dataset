`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data(data),
        .checksum(checksum)
    );
    task testcase001;

    begin
        test_num = 1;
        data = 64'h0000_0000_0000_0000;
        $display("Test %0d: All zeros input", test_num);

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data = 64'h0001_0002_0003_0004;
        $display("Test %0d: Simple small values", test_num);

        #1;


        check_outputs(16'hFFF5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data = 64'hAAAA_1111_2222_2822;
        $display("Test %0d: Sum results in FFFF", test_num);

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data = 64'hFFFF_0001_0000_0000;
        $display("Test %0d: Single carry wrap-around", test_num);

        #1;


        check_outputs(16'hFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data = 64'hFFFF_FFFF_FFFF_FFFF;
        $display("Test %0d: All ones input (Max sum)", test_num);

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data = 64'h1234_5678_9ABC_DEF0;
        $display("Test %0d: Complex data pattern", test_num);

        #1;


        check_outputs(16'h1DA6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data = 64'hAAAA_5555_AAAA_5555;
        $display("Test %0d: Alternating bit pattern", test_num);

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data = 64'h8000_8000_8000_8000;
        $display("Test %0d: Multiple carries from MSBs", test_num);

        #1;


        check_outputs(16'hFFFD);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum;
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
