`timescale 1ns/1ps

module multi_input_output_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg [1:0] in2;
    reg [2:0] in3;
    reg [3:0] in4;
    reg [4:0] in5;
    reg [5:0] in6;
    reg [6:0] in7;
    reg [7:0] in8;
    reg [8:0] in9;
    wire [9:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multi_input_output dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .in9(in9),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: in1=0 (Sum Logic)", test_num);
        in1 = 1'b0;
        in2 = 2'd2;
        in3 = 3'd5;

        in4 = 0; in5 = 0; in6 = 0; in7 = 7'd127; in8 = 0; in9 = 0;
        #1;

        check_outputs(10'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: in1=0 (Max Sum)", test_num);
        in1 = 1'b0;
        in2 = 2'b11;
        in3 = 3'b111;
        #1;

        check_outputs(10'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: in1=1 (OR and Left Shift)", test_num);
        in1 = 1'b1;
        in4 = 4'b1010;
        in5 = 5'b10101;


        #1;



        check_outputs(10'h03E);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: in6 >= in7 (XOR Logic)", test_num);
        in1 = 1'bx;
        in6 = 6'd50;
        in7 = 7'd25;
        in8 = 8'hAA;
        in9 = 9'h155;

        #1;


        check_outputs(10'h1FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: in6 == in7 (XOR Logic)", test_num);
        in1 = 1'bx;
        in6 = 6'd40;
        in7 = 7'd40;
        in8 = 8'hFF;
        in9 = 9'h000;
        #1;

        check_outputs(10'h0FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: in6 < in7 (AND and Right Shift)", test_num);
        in1 = 1'bx;
        in6 = 6'd10;
        in7 = 7'd100;
        in8 = 8'hFF;
        in9 = 9'h1FF;


        #1;



        check_outputs(10'h07F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multi_input_output Testbench");
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
        input [9:0] expected_out;
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
