`timescale 1ns/1ps

module zzadd13_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [12:0] rs1_data;
    reg [12:0] rs2_data;
    wire [12:0] adder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzadd13 dut (
        .cin(cin),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .adder_out(adder_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition", test_num);
            rs1_data = 13'd100;
            rs2_data = 13'd250;
            cin = 1'b0;
            #1;

            check_outputs(13'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry-in", test_num);
            rs1_data = 13'd500;
            rs2_data = 13'd500;
            cin = 1'b1;
            #1;

            check_outputs(13'd1001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Resulting in Zero (All bits 0)", test_num);
            rs1_data = 13'h0000;
            rs2_data = 13'h0000;
            cin = 1'b0;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum 13-bit value Addition (No overflow)", test_num);
            rs1_data = 13'h0FFF;
            rs2_data = 13'h1000;
            cin = 1'b0;
            #1;

            check_outputs(13'h1FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Check (Truncation)", test_num);
            rs1_data = 13'h1FFF;
            rs2_data = 13'h0001;
            cin = 1'b0;

            #1;


            check_outputs(13'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full 13-bit wrap-around with Carry-in", test_num);
            rs1_data = 13'h1FFF;
            rs2_data = 13'h1FFF;
            cin = 1'b1;

            #1;


            check_outputs(13'h1FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern", test_num);
            rs1_data = 13'h0AAA;
            rs2_data = 13'h0555;
            cin = 1'b0;
            #1;

            check_outputs(13'h0FFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit carry propagation test", test_num);
            rs1_data = 13'h1555;
            rs2_data = 13'h0AAA;
            cin = 1'b1;

            #1;


            check_outputs(13'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzadd13 Testbench");
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
        input [12:0] expected_adder_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h",
                         adder_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h",
                         expected_adder_out);
                $display("  Got:      adder_out=%h",
                         adder_out);
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
