`timescale 1ns/1ps

module checksum_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [3:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All bits zero", test_num);
        data_in = 4'b0000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All bits one", test_num);
        data_in = 4'b1111;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit set", test_num);
        data_in = 4'b1000;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two bits set (Alternating)", test_num);
        data_in = 4'b1010;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three bits set", test_num);
        data_in = 4'b0111;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary value", test_num);
        data_in = 4'b1101;
        #1;

        check_outputs(4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum Testbench");
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
        input [3:0] expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
