`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] IR_out;
    reg MemWrite;
    reg [1:0] mem_addr_in;
    reg [31:0] rt_out;
    wire [3:0] mem_byte_write_out;
    wire [31:0] rt_out_shift;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IR_out(IR_out),
        .MemWrite(MemWrite),
        .mem_addr_in(mem_addr_in),
        .rt_out(rt_out),
        .mem_byte_write_out(mem_byte_write_out),
        .rt_out_shift(rt_out_shift)
    );
    task testcase001;

    begin
        test_num = 1;
        IR_out = 6'b101011;
        MemWrite = 1'b1;
        mem_addr_in = 2'b00;
        rt_out = 32'hAABBCCDD;
        $display("Testcase %0d: SW opcode, addr 00", test_num);
        #1;

        check_outputs(4'b1111, 32'hAABBCCDD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        IR_out = 6'b101011;
        MemWrite = 1'b1;
        mem_addr_in = 2'b11;
        rt_out = 32'h12345678;
        $display("Testcase %0d: SW opcode, addr 11", test_num);
        #1;

        check_outputs(4'b1111, 32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        IR_out = 6'b000000;
        MemWrite = 1'b1;
        mem_addr_in = 2'b00;
        rt_out = 32'h000000FF;
        $display("Testcase %0d: Other opcode, addr 00", test_num);
        #1;

        check_outputs(4'b0001, 32'h000000FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        IR_out = 6'b101000;
        MemWrite = 1'b1;
        mem_addr_in = 2'b01;
        rt_out = 32'h12345678;
        $display("Testcase %0d: Other opcode, addr 01", test_num);

        #1;


        check_outputs(4'b0010, 32'h34567800);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        IR_out = 6'b111111;
        MemWrite = 1'b1;
        mem_addr_in = 2'b10;
        rt_out = 32'h12345678;
        $display("Testcase %0d: Other opcode, addr 10", test_num);

        #1;


        check_outputs(4'b0100, 32'h56780000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        IR_out = 6'b010101;
        MemWrite = 1'b1;
        mem_addr_in = 2'b11;
        rt_out = 32'h12345678;
        $display("Testcase %0d: Other opcode, addr 11", test_num);

        #1;


        check_outputs(4'b1000, 32'h78000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        IR_out = 6'b101011;
        MemWrite = 1'b0;
        mem_addr_in = 2'b00;
        rt_out = 32'hDEADBEEF;
        $display("Testcase %0d: SW opcode, MemWrite=0", test_num);
        #1;

        check_outputs(4'b0000, 32'hDEADBEEF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        IR_out = 6'b000000;
        MemWrite = 1'b0;
        mem_addr_in = 2'b01;
        rt_out = 32'h12345678;
        $display("Testcase %0d: Other opcode, addr 01, MemWrite=0", test_num);
        #1;

        check_outputs(4'b0000, 32'h34567800);
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
        input [3:0] expected_mem_byte_write_out;
        input [31:0] expected_rt_out_shift;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_byte_write_out === (expected_mem_byte_write_out ^ mem_byte_write_out ^ expected_mem_byte_write_out) &&
                expected_rt_out_shift === (expected_rt_out_shift ^ rt_out_shift ^ expected_rt_out_shift)) begin
                $display("PASS");
                $display("  Outputs: mem_byte_write_out=%h, rt_out_shift=%h",
                         mem_byte_write_out, rt_out_shift);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_byte_write_out=%h, rt_out_shift=%h",
                         expected_mem_byte_write_out, expected_rt_out_shift);
                $display("  Got:      mem_byte_write_out=%h, rt_out_shift=%h",
                         mem_byte_write_out, rt_out_shift);
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
