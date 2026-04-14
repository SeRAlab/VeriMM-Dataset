`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] add_in;
    reg [31:0] and_in;
    reg [31:0] mov_in;
    reg [31:0] not_in;
    reg [2:0] opcode;
    reg [31:0] or_in;
    reg [31:0] sub_in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_in(add_in),
        .and_in(and_in),
        .mov_in(mov_in),
        .not_in(not_in),
        .opcode(opcode),
        .or_in(or_in),
        .sub_in(sub_in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Opcode 000 - Select mov_in", test_num);
        mov_in = 32'hAAAA_AAAA;
        not_in = 32'h0000_0000;
        add_in = 32'h1111_1111;
        sub_in = 32'h2222_2222;
        or_in  = 32'h3333_3333;
        and_in = 32'h4444_4444;
        opcode = 3'b000;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Opcode 001 - Select not_in", test_num);
        mov_in = 32'h0000_0000;
        not_in = 32'hBBBB_BBBB;
        add_in = 32'h1111_1111;
        sub_in = 32'h2222_2222;
        or_in  = 32'h3333_3333;
        and_in = 32'h4444_4444;
        opcode = 3'b001;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Opcode 010 - Select add_in", test_num);
        mov_in = 32'h1111_1111;
        not_in = 32'h2222_2222;
        add_in = 32'hCCCC_CCCC;
        sub_in = 32'h3333_3333;
        or_in  = 32'h4444_4444;
        and_in = 32'h5555_5555;
        opcode = 3'b010;
        #1;

        check_outputs(32'hCCCC_CCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Opcode 011 - Select sub_in", test_num);
        mov_in = 32'h1111_1111;
        not_in = 32'h2222_2222;
        add_in = 32'h3333_3333;
        sub_in = 32'hDDDD_DDDD;
        or_in  = 32'h4444_4444;
        and_in = 32'h5555_5555;
        opcode = 3'b011;
        #1;

        check_outputs(32'hDDDD_DDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Opcode 100 - Select or_in", test_num);
        mov_in = 32'h1111_1111;
        not_in = 32'h2222_2222;
        add_in = 32'h3333_3333;
        sub_in = 32'h4444_4444;
        or_in  = 32'hEEEE_EEEE;
        and_in = 32'h5555_5555;
        opcode = 3'b100;
        #1;

        check_outputs(32'hEEEE_EEEE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Opcode 101 - Select and_in", test_num);
        mov_in = 32'h1111_1111;
        not_in = 32'h2222_2222;
        add_in = 32'h3333_3333;
        sub_in = 32'h4444_4444;
        or_in  = 32'h5555_5555;
        and_in = 32'hFFFF_FFFF;
        opcode = 3'b101;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Opcode 110 - Default Case (Expected 0)", test_num);
        mov_in = 32'h1111_1111;
        not_in = 32'h2222_2222;
        add_in = 32'h3333_3333;
        sub_in = 32'h4444_4444;
        or_in  = 32'h5555_5555;
        and_in = 32'h6666_6666;
        opcode = 3'b110;

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Opcode 111 - Default Case (Expected 0)", test_num);
        mov_in = 32'h1111_1111;
        not_in = 32'h2222_2222;
        add_in = 32'h3333_3333;
        sub_in = 32'h4444_4444;
        or_in  = 32'h5555_5555;
        and_in = 32'h6666_6666;
        opcode = 3'b111;
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
