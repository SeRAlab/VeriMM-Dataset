`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg start;
    wire [15:0] checksum;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data(data),
        .start(start),
        .checksum(checksum),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple sum without carry", test_num);

            data = 32'h0001_0002;
            start = 1'b1;
            #10;
            #1;

            check_outputs(16'hFFFC, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum with end-around carry", test_num);

            data = 32'hFFFF_0001;
            start = 1'b1;
            #10;
            #1;

            check_outputs(16'hFFFE, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);

            data = 32'h0000_0000;
            start = 1'b1;
            #10;
            #1;

            check_outputs(16'hFFFF, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum inputs (All ones)", test_num);

            data = 32'hFFFF_FFFF;
            start = 1'b1;
            #10;
            #1;

            check_outputs(16'h0000, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard IP header values", test_num);

            data = 32'h4500_003C;
            start = 1'b1;
            #10;
            #1;

            check_outputs(16'hBAC3, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values with carry", test_num);

            data = 32'hAABB_CCDD;
            start = 1'b1;
            #10;
            #1;

            check_outputs(16'h8866, 1'b1);
            start = 1'b0;
            #10;
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, valid=%b",
                         checksum, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, valid=%b",
                         expected_checksum, expected_valid);
                $display("  Got:      checksum=%h, valid=%b",
                         checksum, valid);
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
