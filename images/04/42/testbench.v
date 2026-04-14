`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg [15:0] data2;
    reg [15:0] data3;
    reg [15:0] data4;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .checksum(checksum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Zeros", test_num);
        data0 = 16'h0000;
        data1 = 16'h0000;
        data2 = 16'h0000;
        data3 = 16'h0000;
        data4 = 16'h0000;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Simple small values", test_num);
        data0 = 16'h0001;
        data1 = 16'h0002;
        data2 = 16'h0003;
        data3 = 16'h0004;
        data4 = 16'h0005;
        #1;

        check_outputs(16'hFFF0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Simple carry wrap-around", test_num);
        data0 = 16'hFFFF;
        data1 = 16'h0001;
        data2 = 16'h0000;
        data3 = 16'h0000;
        data4 = 16'h0000;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Maximum values", test_num);
        data0 = 16'hFFFF;
        data1 = 16'hFFFF;
        data2 = 16'hFFFF;
        data3 = 16'hFFFF;
        data4 = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: IP Header-style values", test_num);
        data0 = 16'h4500;
        data1 = 16'h003C;
        data2 = 16'h1C46;
        data3 = 16'h4000;
        data4 = 16'h4006;
        #1;

        check_outputs(16'h1E77);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Large carry wrap", test_num);
        data0 = 16'hAAAA;
        data1 = 16'hBBBB;
        data2 = 16'hCCCC;
        data3 = 16'hDDDD;
        data4 = 16'hEEEE;
        #1;

        check_outputs(16'hFFFC);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Mixed values with wrap", test_num);
        data0 = 16'h1234;
        data1 = 16'h5678;
        data2 = 16'h9ABC;
        data3 = 16'hDEF0;
        data4 = 16'h1111;
        #1;

        check_outputs(16'h0C95);
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
