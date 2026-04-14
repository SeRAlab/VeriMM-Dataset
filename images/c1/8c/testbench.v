`timescale 1ns/1ps

module zzadd34c_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [33:0] rs1_data;
    reg [33:0] rs2_data;
    wire [33:0] adder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzadd34c dut (
        .cin(cin),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .adder_out(adder_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition", test_num);
            rs1_data = 34'h0;
            rs2_data = 34'h0;
            cin = 1'b0;
            #1;

            check_outputs(34'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (No Carry-in)", test_num);
            rs1_data = 34'h000000123;
            rs2_data = 34'h000000456;
            cin = 1'b0;
            #1;

            check_outputs(34'h000000579);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (With Carry-in)", test_num);
            rs1_data = 34'h00000000F;
            rs2_data = 34'h000000001;
            cin = 1'b1;
            #1;

            check_outputs(34'h000000011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Addition (Modulo Overflow)", test_num);
            rs1_data = 34'h3FFFFFFFF;
            rs2_data = 34'h000000001;
            cin = 1'b0;
            #1;

            check_outputs(34'h000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Addition with Carry-in", test_num);
            rs1_data = 34'h3FFFFFFFF;
            rs2_data = 34'h3FFFFFFFF;
            cin = 1'b1;
            #1;

            check_outputs(34'h3FFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Pattern Alternation", test_num);
            rs1_data = 34'h2AAAAAAAA;
            rs2_data = 34'h155555555;
            cin = 1'b0;
            #1;

            check_outputs(34'h3FFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Ripple across all bits", test_num);
            rs1_data = 34'h3FFFFFFFE;
            rs2_data = 34'h000000001;
            cin = 1'b1;
            #1;

            check_outputs(34'h000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzadd34c Testbench");
        $display("========================================");


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
        input [33:0] expected_adder_out;
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
