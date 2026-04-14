`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] cal_result;
    reg clock;
    reg lw;
    reg [31:0] mem_content;
    reg nop;
    reg [4:0] rd;
    reg reset;
    reg we;
    reg wren;
    wire [11:0] address_dmem;
    wire out_nop;
    wire out_rd;
    wire out_we;
    wire out_wren;
    wire [31:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cal_result(cal_result),
        .clock(clock),
        .lw(lw),
        .mem_content(mem_content),
        .nop(nop),
        .rd(rd),
        .reset(reset),
        .we(we),
        .wren(wren),
        .address_dmem(address_dmem),
        .out_nop(out_nop),
        .out_rd(out_rd),
        .out_we(out_we),
        .out_wren(out_wren),
        .value(value)
    );
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        clock = 0;
        nop = 0; lw = 0; mem_content = 0; cal_result = 0; rd = 5'b0; we = 0; wren = 0;

        #10 clock = 1; #10 clock = 0;
        reset = 0;





        #1;






        check_outputs(12'h000, 1'b0, 1'b0, 1'b0, 1'b0, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset = 1; #10; reset = 0;

        lw = 1'b1;
        mem_content = 32'hDEADBEEF;
        cal_result = 32'h12345678;
        rd = 5'b00001;
        we = 1'b1;
        wren = 1'b0;
        nop = 1'b0;

        #10 clock = 1; #10 clock = 0;



        #1;




        check_outputs(12'h678, 1'b0, 1'b1, 1'b1, 1'b0, 32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset = 1; #10; reset = 0;

        lw = 1'b0;
        mem_content = 32'hCAFEBABE;
        cal_result = 32'h87654321;
        rd = 5'b00000;
        we = 1'b0;
        wren = 1'b1;
        nop = 1'b0;

        #10 clock = 1; #10 clock = 0;



        #1;




        check_outputs(12'h321, 1'b0, 1'b0, 1'b0, 1'b1, 32'h87654321);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset = 1; #10; reset = 0;

        lw = 1'b0;
        cal_result = 32'hFFFF_FABC;
        rd = 5'b11111;
        we = 1'b1;
        wren = 1'b1;
        nop = 1'b0;

        #10 clock = 1; #10 clock = 0;


        #1;



        check_outputs(12'hABC, 1'b0, 1'b1, 1'b1, 1'b1, 32'hFFFF_FABC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset = 1; #10; reset = 0;

        nop = 1'b1;
        lw = 1'b0;
        cal_result = 32'h0;
        rd = 5'b0;
        we = 1'b0;
        wren = 1'b0;

        #10 clock = 1; #10 clock = 0;

        #1;


        check_outputs(12'h000, 1'b1, 1'b0, 1'b0, 1'b0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset = 1; #10; reset = 0;

        lw = 1'b1;
        mem_content = 32'hAAAA_5555;
        cal_result = 32'h5555_1234;
        rd = 5'b10101;
        we = 1'b0;
        wren = 1'b1;
        nop = 1'b1;

        #10 clock = 1; #10 clock = 0;




        #1;





        check_outputs(12'h234, 1'b1, 1'b1, 1'b0, 1'b1, 32'hAAAA_5555);
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
        input [11:0] expected_address_dmem;
        input expected_out_nop;
        input expected_out_rd;
        input expected_out_we;
        input expected_out_wren;
        input [31:0] expected_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address_dmem === (expected_address_dmem ^ address_dmem ^ expected_address_dmem) &&
                expected_out_nop === (expected_out_nop ^ out_nop ^ expected_out_nop) &&
                expected_out_rd === (expected_out_rd ^ out_rd ^ expected_out_rd) &&
                expected_out_we === (expected_out_we ^ out_we ^ expected_out_we) &&
                expected_out_wren === (expected_out_wren ^ out_wren ^ expected_out_wren) &&
                expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: address_dmem=%h, out_nop=%b, out_rd=%b, out_we=%b, out_wren=%b, value=%h",
                         address_dmem, out_nop, out_rd, out_we, out_wren, value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_dmem=%h, out_nop=%b, out_rd=%b, out_we=%b, out_wren=%b, value=%h",
                         expected_address_dmem, expected_out_nop, expected_out_rd, expected_out_we, expected_out_wren, expected_value);
                $display("  Got:      address_dmem=%h, out_nop=%b, out_rd=%b, out_we=%b, out_wren=%b, value=%h",
                         address_dmem, out_nop, out_rd, out_we, out_wren, value);
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
