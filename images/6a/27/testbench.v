`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALU;
    reg [31:0] D;
    reg DT;
    reg Sign;
    wire [31:0] ND;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU(ALU),
        .D(D),
        .DT(DT),
        .Sign(Sign),
        .ND(ND)
    );
    task testcase001;

    begin
        test_num = 1;
        D = 32'hA5B6C7D8;
        ALU = 2'b00;
        DT = 1'b0;
        Sign = 1'b0;
        #10;
        #1;

        check_outputs(32'hA5B6C7D8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        D = 32'hA5B6C7D8;
        ALU = 2'b00;
        DT = 1'b1;
        Sign = 1'b1;
        #10;
        #1;

        check_outputs(32'h000000D8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        D = 32'hA5B6C7D8;
        ALU = 2'b01;
        DT = 1'b1;
        Sign = 1'b1;
        #10;
        #1;

        check_outputs(32'h000000C7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        D = 32'hA5B6C7D8;
        ALU = 2'b10;
        DT = 1'b1;
        Sign = 1'b1;
        #10;
        #1;

        check_outputs(32'h000000B6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        D = 32'hA5B6C7D8;
        ALU = 2'b11;
        DT = 1'b1;
        Sign = 1'b1;
        #10;
        #1;

        check_outputs(32'h000000A5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        D = 32'hA5B6C7D8;
        ALU = 2'b00;
        DT = 1'b1;
        Sign = 1'b0;
        #10;
        #1;

        check_outputs(32'hFFFFFFD8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        D = 32'hA5B6C7D8;
        ALU = 2'b01;
        DT = 1'b1;
        Sign = 1'b0;
        #10;
        #1;

        check_outputs(32'hFFFFFFC7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        D = 32'hA5B6C7D8;
        ALU = 2'b10;
        DT = 1'b1;
        Sign = 1'b0;
        #10;
        #1;

        check_outputs(32'hFFFFFFB6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        D = 32'hA5B6C7D8;
        ALU = 2'b11;
        DT = 1'b1;
        Sign = 1'b0;
        #10;
        #1;

        check_outputs(32'hFFFFFFA5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        D = 32'h12345678;
        ALU = 2'b00;
        DT = 1'b1;
        Sign = 1'b0;
        #10;
        #1;

        check_outputs(32'h00000078);
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
        input [31:0] expected_ND;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ND === (expected_ND ^ ND ^ expected_ND)) begin
                $display("PASS");
                $display("  Outputs: ND=%h",
                         ND);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ND=%h",
                         expected_ND);
                $display("  Got:      ND=%h",
                         ND);
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
