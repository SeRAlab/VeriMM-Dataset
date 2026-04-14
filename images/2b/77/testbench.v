`timescale 1ns/1ps

module binary_to_7seg_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] binary_in;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_7seg dut (
        .binary_in(binary_in),
        .seg(seg)
    );
    task testcase000;

        begin
            test_num = 0;
            $display("\nTest Case %0d: Binary Input = 000", test_num);
            binary_in = 3'b000;

            #1;


            check_outputs(7'h7E);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Binary Input = 001", test_num);
            binary_in = 3'b001;

            #1;


            check_outputs(7'h30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Binary Input = 010", test_num);
            binary_in = 3'b010;

            #1;


            check_outputs(7'h6D);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Binary Input = 011", test_num);
            binary_in = 3'b011;

            #1;


            check_outputs(7'h79);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Binary Input = 100", test_num);
            binary_in = 3'b100;

            #1;


            check_outputs(7'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Binary Input = 101", test_num);
            binary_in = 3'b101;

            #1;


            check_outputs(7'h5B);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Binary Input = 110", test_num);
            binary_in = 3'b110;

            #1;


            check_outputs(7'h5F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Binary Input = 111", test_num);
            binary_in = 3'b111;

            #1;


            check_outputs(7'h70);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_7seg Testbench");
        $display("========================================");


        testcase000();
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
