`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] abus_out;
    reg [2:0] alu_op;
    reg [31:0] bbus_out;
    reg clock;
    wire [31:0] cbus_in;
    wire n;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .abus_out(abus_out),
        .alu_op(alu_op),
        .bbus_out(bbus_out),
        .clock(clock),
        .cbus_in(cbus_in),
        .n(n),
        .z(z)
    );
    task reset_inputs;

        begin
            abus_out = 32'h0;
            bbus_out = 32'h0;
            alu_op = 3'b000;
            @(posedge clock);
            #1;
        end
        endtask

    task testcase001;

    begin
        reset_inputs();
        test_num = 1;
        $display("Testcase %0d: Move Operation", test_num);
        abus_out = 32'hA5A5A5A5;
        bbus_out = 32'hFFFFFFFF;
        alu_op = 3'b000;
        @(posedge clock);
        #1;

        check_outputs(32'hA5A5A5A5, 1, 0);
    end
        endtask

    task testcase002;

    begin
        reset_inputs();
        test_num = 2;
        $display("Testcase %0d: Addition", test_num);
        abus_out = 32'h00000010;
        bbus_out = 32'h00000020;
        alu_op = 3'b001;
        @(posedge clock);
        #1;

        check_outputs(32'h00000030, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_inputs();
        test_num = 3;
        $display("Testcase %0d: Subtraction (Result Zero)", test_num);
        abus_out = 32'h000000FF;
        bbus_out = 32'h000000FF;
        alu_op = 3'b010;
        @(posedge clock);
        #1;

        check_outputs(32'h00000000, 0, 1);
    end
        endtask

    task testcase004;

    begin
        reset_inputs();
        test_num = 4;
        $display("Testcase %0d: Subtraction (Result Negative)", test_num);
        abus_out = 32'h00000005;
        bbus_out = 32'h0000000A;
        alu_op = 3'b010;
        @(posedge clock);

        #1;


        check_outputs(32'hFFFFFFFB, 1, 0);
    end
        endtask

    task testcase005;

    begin
        reset_inputs();
        test_num = 5;
        $display("Testcase %0d: Multiplication", test_num);
        abus_out = 32'h00000006;
        bbus_out = 32'h00000007;
        alu_op = 3'b011;
        @(posedge clock);
        #1;

        check_outputs(32'h0000002A, 0, 0);
    end
        endtask

    task testcase006;

    begin
        reset_inputs();
        test_num = 6;
        $display("Testcase %0d: Division", test_num);
        abus_out = 32'h00000064;
        bbus_out = 32'h0000000A;
        alu_op = 3'b100;
        @(posedge clock);
        #1;

        check_outputs(32'h0000000A, 0, 0);
    end
        endtask

    task testcase007;

    begin
        reset_inputs();
        test_num = 7;
        $display("Testcase %0d: Shift Left Logical", test_num);
        abus_out = 32'h00000001;
        bbus_out = 32'h00000004;
        alu_op = 3'b101;
        @(posedge clock);
        #1;

        check_outputs(32'h00000010, 0, 0);
    end
        endtask

    task testcase008;

    begin
        reset_inputs();
        test_num = 8;
        $display("Testcase %0d: Shift Right Logical", test_num);
        abus_out = 32'h00000080;
        bbus_out = 32'h00000003;
        alu_op = 3'b110;
        @(posedge clock);
        #1;

        check_outputs(32'h00000010, 0, 0);
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
        input [31:0] expected_cbus_in;
        input expected_n;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cbus_in === (expected_cbus_in ^ cbus_in ^ expected_cbus_in) &&
                expected_n === (expected_n ^ n ^ expected_n) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: cbus_in=%h, n=%b, z=%b",
                         cbus_in, n, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cbus_in=%h, n=%b, z=%b",
                         expected_cbus_in, expected_n, expected_z);
                $display("  Got:      cbus_in=%h, n=%b, z=%b",
                         cbus_in, n, z);
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
