`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] op1;
    reg [31:0] op2;
    reg [2:0] operation;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op1(op1),
        .op2(op2),
        .operation(operation),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR operation", test_num);
            op1 = 32'hAAAA_AAAA;
            op2 = 32'h5555_5555;
            operation = 3'b000;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR operation (Zeros)", test_num);
            op1 = 32'h0000_0000;
            op2 = 32'h0000_0000;
            operation = 3'b000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND operation", test_num);
            op1 = 32'hFFFF_FFFF;
            op2 = 32'h1234_5678;
            operation = 3'b001;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND operation (Clear)", test_num);
            op1 = 32'hAAAA_AAAA;
            op2 = 32'h5555_5555;
            operation = 3'b001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NOR operation", test_num);
            op1 = 32'h0000_0000;
            op2 = 32'h0000_0000;
            operation = 3'b010;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NOR operation (Complex)", test_num);
            op1 = 32'hF0F0_F0F0;
            op2 = 32'h0F0F_0F0F;
            operation = 3'b010;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR operation (Identity)", test_num);
            op1 = 32'h1234_5678;
            op2 = 32'h1234_5678;
            operation = 3'b011;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR operation (Toggle)", test_num);
            op1 = 32'hFFFF_FFFF;
            op2 = 32'hAAAA_AAAA;
            operation = 3'b011;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR operation (Bit Independence)", test_num);
            op1 = 32'h8000_0001;
            op2 = 32'h0000_0001;
            operation = 3'b011;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND pattern", test_num);
            op1 = 32'hF0F0_AAAA;
            op2 = 32'hFF00_5555;
            operation = 3'b001;
            #1;

            check_outputs(32'hF000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
