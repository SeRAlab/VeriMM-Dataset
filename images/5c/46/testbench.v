`timescale 1ns/1ps

module binary_to_7segment_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_7segment dut (
        .a(a),
        .seg(seg)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input a = 000 (0)", test_num);
        a = 3'b000;
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input a = 001 (1)", test_num);
        a = 3'b001;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input a = 010 (2)", test_num);
        a = 3'b010;
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input a = 011 (3)", test_num);
        a = 3'b011;
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input a = 100 (4)", test_num);
        a = 3'b100;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input a = 101 (5)", test_num);
        a = 3'b101;
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input a = 110 (6)", test_num);
        a = 3'b110;
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input a = 111 (7)", test_num);
        a = 3'b111;
        #1;

        check_outputs(7'h07);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_7segment Testbench");
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
