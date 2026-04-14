`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] address;
    reg [1023:0] inputs;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .inputs(inputs),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select index 0", test_num);
            inputs = 1024'b0;
            inputs[31:0] = 32'hDEADBEEF;
            address = 5'd0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select index 31 (MSB end)", test_num);
            inputs = 1024'b0;
            inputs[1023:992] = 32'hCAFEBABE;
            address = 5'd31;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select index 1", test_num);
            inputs = 1024'b0;
            inputs[63:32] = 32'h12345678;
            address = 5'd1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select index 15 with pattern fill", test_num);
            inputs = {32{32'hAAAA5555}};
            address = 5'd15;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select index 16 (midpoint)", test_num);
            inputs = 0;
            inputs[16*32 +: 32] = 32'hF0F0F0F0;
            address = 5'd16;
            #1;

            check_outputs(32'hF0F0F0F0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Indexed data check (Index 7)", test_num);
            for (i = 0; i < 32; i = i + 1) begin
                inputs[i*32 +: 32] = i + 32'h100;
            end
            address = 5'd7;
            #1;

            check_outputs(32'h107);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Walking address check (Index 23)", test_num);
            for (i = 0; i < 32; i = i + 1) begin
                inputs[i*32 +: 32] = ~i;
            end
            address = 5'd23;
            #1;

            check_outputs(~32'd23);
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
        input [31:0] expected_out;
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
