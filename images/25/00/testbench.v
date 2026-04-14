`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    reg enable;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data(data),
        .enable(enable),
        .checksum(checksum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset and Idle Check", test_num);
        rst_n = 0;
        enable = 0;
        data = 0;
        #20;
        rst_n = 1;
        #10;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Word Check (0x1234)", test_num);
        rst_n = 0; #10; rst_n = 1; #10;

        data = 16'h1234;
        enable = 1;
        #10;
        enable = 0;

        #1;


        check_outputs(16'hEDCB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple Words Accumulation", test_num);
        rst_n = 0; #10; rst_n = 1; #10;

        enable = 1;
        data = 16'h1111; #10;
        data = 16'h2222; #10;
        data = 16'h3333; #10;
        enable = 0;

        #1;


        check_outputs(16'h9999);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: One's Complement Carry Handling", test_num);
        rst_n = 0; #10; rst_n = 1; #10;

        enable = 1;
        data = 16'hFFFF; #10;
        data = 16'h0001; #10;
        enable = 0;

        #1;


        check_outputs(16'hFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Double Carry Handling", test_num);
        rst_n = 0; #10; rst_n = 1; #10;

        enable = 1;
        data = 16'hFFFF; #10;
        data = 16'hFFFF; #10;
        enable = 0;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable Signal Logic Check", test_num);
        rst_n = 0; #10; rst_n = 1; #10;

        enable = 1; data = 16'hAAAA; #10;
        enable = 0; data = 16'h5555; #10;
        enable = 1; data = 16'h1111; #10;
        enable = 0;

        #1;


        check_outputs(16'h4444);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Data Input Check", test_num);
        rst_n = 0; #10; rst_n = 1; #10;

        enable = 1;
        data = 16'h1234; #10;
        data = 16'h0000; #10;
        enable = 0;

        #1;


        check_outputs(16'hEDCB);
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
