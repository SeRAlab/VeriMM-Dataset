`timescale 1ns/1ps

module simple_hash_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in_data;
    wire [2:0] out_hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_hash dut (
        .in_data(in_data),
        .out_hash(out_hash)
    );
    task testcase001;

    begin
        test_num = 1;
        in_data = 5'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in_data = 5'd1;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in_data = 5'd2;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in_data = 5'd3;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in_data = 5'd4;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in_data = 5'd7;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in_data = 5'd8;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in_data = 5'd15;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in_data = 5'd31;
        #1;

        check_outputs(3'd5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_hash Testbench");
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
        input [2:0] expected_out_hash;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_hash === (expected_out_hash ^ out_hash ^ expected_out_hash)) begin
                $display("PASS");
                $display("  Outputs: out_hash=%h",
                         out_hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hash=%h",
                         expected_out_hash);
                $display("  Got:      out_hash=%h",
                         out_hash);
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
