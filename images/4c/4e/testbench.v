`timescale 1ns/1ps

module decoder_5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5to32 dut (
        .a(a),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 0", test_num);
        a = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 31", test_num);
        a = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 1", test_num);
        a = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 30", test_num);
        a = 5'd30;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 15", test_num);
        a = 5'd15;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 16", test_num);
        a = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 10", test_num);
        a = 5'd10;
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input a = 21", test_num);
        a = 5'd21;
        #1;

        check_outputs(32'h00200000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_5to32 Testbench");
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
        input [31:0] expected_y;
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
