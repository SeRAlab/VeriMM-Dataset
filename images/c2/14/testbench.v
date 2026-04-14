`timescale 1ns/1ps

module select2_5_tb;

    // Testbench signals (combinational circuit)
    reg choose;
    reg [4:0] in1;
    reg [4:0] in2;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    select2_5 dut (
        .choose(choose),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select in1 (choose = 0)");
            test_num = test_num + 1;
            in1 = 5'b10101;
            in2 = 5'b01010;
            choose = 1'b0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select in2 (choose = 1)");
            test_num = test_num + 1;
            in1 = 5'b10101;
            in2 = 5'b01010;
            choose = 1'b1;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select in1 with all ones");
            test_num = test_num + 1;
            in1 = 5'b11111;
            in2 = 5'b00000;
            choose = 1'b0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select in2 with all ones");
            test_num = test_num + 1;
            in1 = 5'b00000;
            in2 = 5'b11111;
            choose = 1'b1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select in1 with zero values");
            test_num = test_num + 1;
            in1 = 5'b00000;
            in2 = 5'b10111;
            choose = 1'b0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select in2 with zero values");
            test_num = test_num + 1;
            in1 = 5'b10111;
            in2 = 5'b00000;
            choose = 1'b1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Choose is 'x' (Other value case)");
            test_num = test_num + 1;
            in1 = 5'b11111;
            in2 = 5'b11111;
            choose = 1'bx;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Choose is 'z' (Other value case)");
            test_num = test_num + 1;
            in1 = 5'b01100;
            in2 = 5'b00011;
            choose = 1'bz;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("select2_5 Testbench");
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
        input [4:0] expected_out;
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
