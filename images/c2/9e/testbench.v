`timescale 1ns/1ps

module six_to_one_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    reg in5;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    six_to_one dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All inputs 0 (Expect out=0)");
        in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: in0=1 (Expect out=1)");
        in0 = 1; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: in1=1 (Expect out=1)");
        in0 = 0; in1 = 1; in2 = 0; in3 = 0; in4 = 0; in5 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: in2=1 (Expect out=1)");
        in0 = 0; in1 = 0; in2 = 1; in3 = 0; in4 = 0; in5 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: in3=1 (Expect out=1)");
        in0 = 0; in1 = 0; in2 = 0; in3 = 1; in4 = 0; in5 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: in4=1 (Expect out=1)");
        in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 1; in5 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: in5=1 (Expect out=1)");
        in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Multiple inputs 1 (in0, in5) (Expect out=1)");
        in0 = 1; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: All inputs 1 (Expect out=1)");
        in0 = 1; in1 = 1; in2 = 1; in3 = 1; in4 = 1; in5 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: Alternating inputs (101010) (Expect out=1)");
        in0 = 1; in1 = 0; in2 = 1; in3 = 0; in4 = 1; in5 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("six_to_one Testbench");
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
        testcase010();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
