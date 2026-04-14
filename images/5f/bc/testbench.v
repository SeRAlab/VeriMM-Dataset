`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] IMEM;
    reg [5:0] opcode;
    wire [31:0] odata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IMEM(IMEM),
        .opcode(opcode),
        .odata(odata)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension - Positive Immediate (Opcode 0x08)", test_num);

            opcode = 6'h08;
            IMEM = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension - Negative Immediate (Opcode 0x08)", test_num);

            opcode = 6'h08;
            IMEM = 16'h8005;
            #1;

            check_outputs(32'hFFFF8005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension - Load Word (Opcode 0x23)", test_num);

            opcode = 6'h23;
            IMEM = 16'hFFF0;
            #1;

            check_outputs(32'hFFFFFFF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension - Store Word (Opcode 0x2B)", test_num);

            opcode = 6'h2B;
            IMEM = 16'h0010;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Extension - Logical Immediate (Opcode 0x0C)", test_num);

            opcode = 6'h0C;
            IMEM = 16'h8000;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Extension - Other Opcode (Opcode 0x00)", test_num);

            opcode = 6'h00;
            IMEM = 16'hFFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - All Zeros (Sign Extend Match)", test_num);
            opcode = 6'h08;
            IMEM = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - All Ones (Sign Extend Match)", test_num);
            opcode = 6'h08;
            IMEM = 16'hFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_odata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_odata === (expected_odata ^ odata ^ expected_odata)) begin
                $display("PASS");
                $display("  Outputs: odata=%h",
                         odata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: odata=%h",
                         expected_odata);
                $display("  Got:      odata=%h",
                         odata);
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
