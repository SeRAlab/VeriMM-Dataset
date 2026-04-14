`timescale 1ns/1ps

module binary_converter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_converter dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 4'd0;
            $display("Test Case %0d: Input 0 (in <= 4)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 4'd3;
            $display("Test Case %0d: Input 3 (in <= 4)", test_num);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 4'd4;
            $display("Test Case %0d: Input 4 (Boundary in <= 4)", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 4'd5;
            $display("Test Case %0d: Input 5 (Boundary in > 4)", test_num);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 4'd7;
            $display("Test Case %0d: Input 7 (Example case in > 4)", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 4'd8;
            $display("Test Case %0d: Input 8 (in > 4, bit 2 should be set)", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 4'd10;
            $display("Test Case %0d: Input 10 (in > 4)", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 4'd15;
            $display("Test Case %0d: Input 15 (Max value in > 4)", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_converter Testbench");
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
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
