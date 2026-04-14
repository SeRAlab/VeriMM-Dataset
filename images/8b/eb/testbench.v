`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inp;
    reg isSrl;
    reg [4:0] shamt;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp(inp),
        .isSrl(isSrl),
        .shamt(shamt),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRL - Shift negative number right by 1", test_num);
        inp = 32'h8000_0000;
        shamt = 5'd1;
        isSrl = 1'b1;
        #1;

        check_outputs(32'h4000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRA - Shift negative number right by 1 (sign extension)", test_num);
        inp = 32'h8000_0000;
        shamt = 5'd1;
        isSrl = 1'b0;
        #1;

        check_outputs(32'hC000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRL - Shift by 0", test_num);
        inp = 32'hDEAD_BEEF;
        shamt = 5'd0;
        isSrl = 1'b1;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRA - Shift by 0", test_num);
        inp = 32'h8123_4567;
        shamt = 5'd0;
        isSrl = 1'b0;
        #1;

        check_outputs(32'h8123_4567);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRL - Max shift (31)", test_num);
        inp = 32'hFFFF_FFFF;
        shamt = 5'd31;
        isSrl = 1'b1;
        #1;

        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRA - Max shift (31) on negative number", test_num);
        inp = 32'h8000_0000;
        shamt = 5'd31;
        isSrl = 1'b0;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRA - Max shift (31) on positive number", test_num);
        inp = 32'h7FFF_FFFF;
        shamt = 5'd31;
        isSrl = 1'b0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRL - Shift by 16", test_num);
        inp = 32'hAAAA_5555;
        shamt = 5'd16;
        isSrl = 1'b1;
        #1;

        check_outputs(32'h0000_AAAA);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRA - Shift by 16", test_num);
        inp = 32'hAAAA_5555;
        shamt = 5'd16;
        isSrl = 1'b0;
        #1;

        check_outputs(32'hFFFF_AAAA);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRL - All zeros", test_num);
        inp = 32'h0000_0000;
        shamt = 5'd16;
        isSrl = 1'b1;
        #1;

        check_outputs(32'h0000_0000);
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
