`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] IR_out;
    reg [1:0] mem_addr_in;
    reg [31:0] mem_data_out;
    wire [3:0] Rd_write_byte_en;
    wire [31:0] mem_data_shift;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IR_out(IR_out),
        .mem_addr_in(mem_addr_in),
        .mem_data_out(mem_data_out),
        .Rd_write_byte_en(Rd_write_byte_en),
        .mem_data_shift(mem_data_shift)
    );
    task testcase001;

        begin
            test_num = 1;
            IR_out = 6'b000010;
            mem_addr_in = 2'b00;
            mem_data_out = 32'h12345678;
            #1;

            check_outputs(4'b1111, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            IR_out = 6'b000000;
            mem_addr_in = 2'b00;
            mem_data_out = 32'h12345678;

            #1;


            check_outputs(4'b1111, 32'h00000078);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            IR_out = 6'b000000;
            mem_addr_in = 2'b01;
            mem_data_out = 32'h12345678;

            #1;


            check_outputs(4'b1111, 32'h00000056);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            IR_out = 6'b000000;
            mem_addr_in = 2'b10;
            mem_data_out = 32'h12345678;

            #1;


            check_outputs(4'b1111, 32'h00000034);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            IR_out = 6'b000000;
            mem_addr_in = 2'b11;
            mem_data_out = 32'h12345678;

            #1;


            check_outputs(4'b1111, 32'h00000012);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            IR_out = 6'b000001;
            mem_addr_in = 2'b00;
            mem_data_out = 32'h12345678;

            #1;


            check_outputs(4'b1111, 32'h00005678);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            IR_out = 6'b000001;
            mem_addr_in = 2'b10;
            mem_data_out = 32'h12345678;

            #1;


            check_outputs(4'b1111, 32'h00001234);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            IR_out = 6'b000010;
            mem_addr_in = 2'b00;
            mem_data_out = 32'hAABBCCDD;
            #1;

            check_outputs(4'b1111, 32'hAABBCCDD);
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
        input [3:0] expected_Rd_write_byte_en;
        input [31:0] expected_mem_data_shift;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Rd_write_byte_en === (expected_Rd_write_byte_en ^ Rd_write_byte_en ^ expected_Rd_write_byte_en) &&
                expected_mem_data_shift === (expected_mem_data_shift ^ mem_data_shift ^ expected_mem_data_shift)) begin
                $display("PASS");
                $display("  Outputs: Rd_write_byte_en=%h, mem_data_shift=%h",
                         Rd_write_byte_en, mem_data_shift);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rd_write_byte_en=%h, mem_data_shift=%h",
                         expected_Rd_write_byte_en, expected_mem_data_shift);
                $display("  Got:      Rd_write_byte_en=%h, mem_data_shift=%h",
                         Rd_write_byte_en, mem_data_shift);
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
