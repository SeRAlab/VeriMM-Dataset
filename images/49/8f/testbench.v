`timescale 1ns/1ps

module decoder_6to64_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] a;
    wire [63:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_6to64 dut (
        .a(a),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 0", test_num);
        a = 6'd0;
        #1;

        check_outputs(64'h0000000000000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 63", test_num);
        a = 6'd63;
        #1;

        check_outputs(64'h8000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 31", test_num);
        a = 6'd31;
        #1;

        check_outputs(64'h0000000080000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 32", test_num);
        a = 6'd32;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 15", test_num);
        a = 6'd15;
        #1;

        check_outputs(64'h0000000000008000);
    end
        endtask

    task testcase006;

    integer i;
    begin
        $display("Test Case %0d: Exhaustive verification (0-63)", test_num + 1);
        for (i = 0; i < 64; i = i + 1) begin
            test_num = test_num + 1;
            a = i;
            #1;

            check_outputs(64'h1 << i);
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_6to64 Testbench");
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
        input [63:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
